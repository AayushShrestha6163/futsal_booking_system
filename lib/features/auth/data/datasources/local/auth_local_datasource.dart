import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futal_booking_system/core/services/hive/hive_service.dart';
import 'package:futal_booking_system/core/services/storage/user_session_service.dart';
import 'package:futal_booking_system/features/auth/data/datasources/auth_datasource.dart';
import 'package:futal_booking_system/features/auth/data/models/auth_hive_model.dart';


final authLocalDatasourceProvider = Provider<AuthLocalDatasource>((ref) {
  final hiveService = ref.read(hiveServiceProvider);
  final userSessionService = ref.read(userSessionServiceProvider);
  return AuthLocalDatasource(
    hiveService: hiveService,
    userSessionService: userSessionService,
  );
});

class AuthLocalDatasource implements IAuthLocalDataSource {
  final HiveService _hiveService;
  final UserSessionService _userSessionService;

  AuthLocalDatasource({
    required HiveService hiveService,
    required UserSessionService userSessionService,
  })  : _hiveService = hiveService,
        _userSessionService = userSessionService;

  @override
  Future<bool> register(AuthHiveModel user) async {
    try {
      await _hiveService.register(user);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<AuthHiveModel?> login(String email, String password) async {
    try {
      final user = _hiveService.login(email, password);

      
      if (user != null && user.authId != null) {
        await _userSessionService.saveUserSession(
          userId: user.authId!,
          email: user.email,
          
          username: "${user.firstName} ${user.lastName}",
          profilePicture: user.profilePicture,
        );
      }

      return Future.value(user);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<AuthHiveModel?> getCurrentUser(userId) async {
    try {
      
      if (!_userSessionService.isLoggedIn()) return null;

      
      final currentUserId = _userSessionService.getCurrentUserId();
      if (currentUserId == null) return null;

      
      return _hiveService.getUserById(currentUserId);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> logout() async {
    try {
      await _userSessionService.clearSession();
      return true;
    } catch (e) {
      return false;
    }
  }
}