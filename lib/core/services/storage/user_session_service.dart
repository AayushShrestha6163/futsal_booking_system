import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// SharedPreferences instance provider
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be overridden in main.dart');
});

// UserSessionService provider
final userSessionServiceProvider = Provider<UserSessionService>((ref) {
  final prefs = ref.read(sharedPreferencesProvider);
  return UserSessionService(prefs: prefs);
});

class UserSessionService {
  final SharedPreferences _prefs;

  // Normal login session keys
  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyUserId = 'user_id';
  static const String _keyUserEmail = 'user_email';
  static const String _keyUserUsername = 'user_username';
  static const String _keyUserPhoneNumber = 'user_phone_number';
  static const String _keyUserBatchId = 'user_batch_id';
  static const String _keyUserProfilePicture = 'user_profile_picture';

  // Biometric login keys
  static const String _keyBiometricEnabled = 'biometric_enabled';
  static const String _keyBiometricEmail = 'biometric_email';

  UserSessionService({required SharedPreferences prefs}) : _prefs = prefs;

  // Save normal user session after login
  Future<void> saveUserSession({
    String? userId,
    String? email,
    String? username,
    String? phoneNumber,
    String? batchId,
    String? profilePicture,
    String? role,
  }) async {
    await _prefs.setBool(_keyIsLoggedIn, true);

    if (userId != null) {
      await _prefs.setString(_keyUserId, userId);
    }
    if (email != null) {
      await _prefs.setString(_keyUserEmail, email);
    }
    if (username != null) {
      await _prefs.setString(_keyUserUsername, username);
    }
    if (phoneNumber != null) {
      await _prefs.setString(_keyUserPhoneNumber, phoneNumber);
    }
    if (batchId != null) {
      await _prefs.setString(_keyUserBatchId, batchId);
    }
    if (profilePicture != null) {
      await _prefs.setString(_keyUserProfilePicture, profilePicture);
    }
  }

  // Save biometric login info after successful normal login
  Future<void> saveBiometricLogin({
    required String email,
  }) async {
    await _prefs.setBool(_keyBiometricEnabled, true);
    await _prefs.setString(_keyBiometricEmail, email);
  }

  // Check if biometric login is enabled
  bool isBiometricLoginEnabled() {
    return _prefs.getBool(_keyBiometricEnabled) ?? false;
  }

  // Get saved biometric email
  String? getBiometricEmail() {
    return _prefs.getString(_keyBiometricEmail);
  }

  // Clear biometric login info
  Future<void> clearBiometricLogin() async {
    await _prefs.remove(_keyBiometricEnabled);
    await _prefs.remove(_keyBiometricEmail);
  }

  // Check if user is logged in
  bool isLoggedIn() {
    return _prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  // Get current user ID
  String? getCurrentUserId() {
    return _prefs.getString(_keyUserId);
  }

  // Get current user email
  String? getCurrentUserEmail() {
    return _prefs.getString(_keyUserEmail);
  }

  // Get current user username
  String? getCurrentUserUsername() {
    return _prefs.getString(_keyUserUsername);
  }

  // Get current user phone number
  String? getCurrentUserPhoneNumber() {
    return _prefs.getString(_keyUserPhoneNumber);
  }

  // Get current user batch ID
  String? getCurrentUserBatchId() {
    return _prefs.getString(_keyUserBatchId);
  }

  // Get current user profile picture
  String? getCurrentUserProfilePicture() {
    return _prefs.getString(_keyUserProfilePicture);
  }

  // Clear only normal login session
  Future<void> clearLoginSession() async {
    await _prefs.remove(_keyIsLoggedIn);
    await _prefs.remove(_keyUserId);
    await _prefs.remove(_keyUserEmail);
    await _prefs.remove(_keyUserUsername);
    await _prefs.remove(_keyUserPhoneNumber);
    await _prefs.remove(_keyUserBatchId);
    await _prefs.remove(_keyUserProfilePicture);
  }

  // Clear everything
  Future<void> clearSession() async {
    await clearLoginSession();
    await clearBiometricLogin();
  }
}