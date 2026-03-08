import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futal_booking_system/core/api/api_client.dart';
import 'package:futal_booking_system/core/api/api_endpoints.dart';
import 'package:futal_booking_system/core/services/storage/token_service.dart';
import 'package:futal_booking_system/core/services/storage/user_session_service.dart';
import 'package:futal_booking_system/features/profile/data/datasources/profile_datasource.dart';
import 'package:futal_booking_system/features/profile/data/models/profile_model.dart';

final profileRemoteDatasourceProvider = Provider<IProfileRemoteDatasource>((ref) {
  return ProfileRemoteDatasource(
    apiClient: ref.read(apiClientProvider),
    userSessionService: ref.read(userSessionServiceProvider),
    tokenService: ref.read(tokenServiceProvider),
  );
});

class ProfileRemoteDatasource implements IProfileRemoteDatasource {
  final ApiClient _apiClient;
  final UserSessionService _userSessionService;
  final TokenService _tokenService;

  ProfileRemoteDatasource({
    required ApiClient apiClient,
    required UserSessionService userSessionService,
    required TokenService tokenService,
  })  : _apiClient = apiClient,
        _userSessionService = userSessionService,
        _tokenService = tokenService;

  @override
  Future<ProfileModel?> updatePersonalInfo(ProfileModel personalInfo) async {
    final formData = FormData.fromMap({
      "firstName": personalInfo.firstName,
      "lastName": personalInfo.lastName,
      if (personalInfo.profile != null)
        "profile": await MultipartFile.fromFile(
          personalInfo.profile!.path,
          filename: personalInfo.profile!.path.split('/').last,
        ),
    });

    final response = await _apiClient.put(
      ApiEndpoints.updateProfile,
      data: formData,
      options: Options(contentType: "multipart/form-data"),
    );

    if (response.data is Map && response.data['success'] == true) {
      final data = response.data['data'] as Map<String, dynamic>;
      final updatedUser = ProfileModel.fromJson(data);

      await _userSessionService.saveUserSession(
        userId: updatedUser.userId,
        username:
            "${updatedUser.firstName ?? ""} ${updatedUser.lastName ?? ""}".trim(),
        profilePicture: updatedUser.profilePicture,
      );

      return updatedUser;
    }

    return null;
  }

  @override
  Future<ProfileModel?> getUserById(String userId) async {
    final response = await _apiClient.get('${ApiEndpoints.getUser}/$userId');

    if (response.data is Map && response.data['success'] == true) {
      final data = response.data['data'] as Map<String, dynamic>;
      return ProfileModel.fromJson(data);
    }

    return null;
  }
}