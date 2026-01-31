import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futal_booking_system/core/api/api_client.dart';
import 'package:futal_booking_system/core/api/api_endpoints.dart';
import 'package:futal_booking_system/core/services/storage/token_service.dart';
import 'package:futal_booking_system/core/services/storage/user_session_service.dart';
import 'package:futal_booking_system/features/auth/data/datasources/auth_datasource.dart';
import 'package:futal_booking_system/features/auth/data/models/auth_api_model.dart';

// Create provider
final authRemoteDatasourceProvider = Provider<IAuthRemoteDataSource>((ref) {
  return AuthRemoteDatasource(
    apiClient: ref.read(apiClientProvider),
    userSessionService: ref.read(userSessionServiceProvider),
    tokenSessionService: ref.read(tokenServiceProvider),
  );
});

class AuthRemoteDatasource implements IAuthRemoteDataSource {
  final ApiClient _apiClient;
  final UserSessionService _userSessionService;
  final TokenService _tokenSessionService;

  AuthRemoteDatasource({
    required ApiClient apiClient,
    required UserSessionService userSessionService,
    required TokenService tokenSessionService,
  }) : _apiClient = apiClient,
       _userSessionService = userSessionService,
       _tokenSessionService = tokenSessionService;

  @override
  Future<AuthApiModel?> getCurrentUser() {
    // TODO: implement getCurrentUser
    throw UnimplementedError();
  }

  @override
  Future<bool> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  Future<AuthApiModel> register(AuthApiModel user) async {
    final response = await _apiClient.post(
      ApiEndpoints.userRegister,
      data: user.toJson(),
    );

    if (response.data['success'] == true) {
      final data = response.data['data'] as Map<String, dynamic>;
      final registeredUser = AuthApiModel.fromJson(data);
      return registeredUser;
    }

    return user;
  }

  @override
  Future<AuthApiModel?> login(String email, String password) async {
    final response = await _apiClient.post(
      ApiEndpoints.userLogin,
      data: {'email': email, 'password': password},
    );

    if (response.data['success'] == true) {
      final data = response.data['data'] as Map<String, dynamic>;
      final user = AuthApiModel.fromJson(data);

      final token = response.data['token'] as String;
      await _tokenSessionService.saveToken(token);

      await _userSessionService.saveUserSession(
        userId: user.id,
        email: user.email,
      );
      return user;
    }

    return null;
  }
}
