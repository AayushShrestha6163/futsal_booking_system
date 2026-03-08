import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futal_booking_system/core/services/storage/token_service.dart';
import 'package:futal_booking_system/core/services/storage/user_session_service.dart';
import 'package:futal_booking_system/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:futal_booking_system/features/auth/domain/usecases/login_usecase.dart';
import 'package:futal_booking_system/features/auth/domain/usecases/register_usecase.dart';
import 'package:futal_booking_system/features/auth/presentation/state/auth_state.dart';

final authViewModelProvider = NotifierProvider<AuthViewModel, AuthState>(
  AuthViewModel.new,
);

class AuthViewModel extends Notifier<AuthState> {
  late final RegisterUsecase _registerUsecase;
  late final LoginUsecase _loginUsecase;
  late final GetCurrentUserUsecase _getCurrentUserUsecase;

  @override
  AuthState build() {
    _registerUsecase = ref.read(registerUsecaseProvider);
    _loginUsecase = ref.read(loginUsecaseProvider);
    _getCurrentUserUsecase = ref.read(getCurrentUserUsecaseProvider);
    return const AuthState();
  }

  Future<void> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    state = state.copyWith(
      status: AuthStatus.loading,
      errorMessage: null,
    );

    final result = await _registerUsecase(
      RegisterParams(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
      ),
    );

    result.fold(
      (failure) {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.message,
        );
      },
      (_) {
        state = state.copyWith(
          status: AuthStatus.registered,
          errorMessage: null,
        );
      },
    );
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(
      status: AuthStatus.loading,
      errorMessage: null,
    );

    final result = await _loginUsecase(
      LoginParams(
        email: email,
        password: password,
      ),
    );

    await result.fold(
      (failure) async {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.message,
        );
      },
      (user) async {
        await _saveUserToSession(user);

        final cleanEmail = (user.email ?? email).toString().trim();
        if (cleanEmail.isNotEmpty) {
          await ref.read(userSessionServiceProvider).saveBiometricLogin(
                email: cleanEmail,
              );
        }

        state = state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
          errorMessage: null,
        );
      },
    );
  }

  Future<void> fingerprintLogin() async {
    state = state.copyWith(
      status: AuthStatus.loading,
      errorMessage: null,
    );

    final session = ref.read(userSessionServiceProvider);
    final tokenService = ref.read(tokenServiceProvider);

    final token = await tokenService.getToken();
    final biometricEnabled = session.isBiometricLoginEnabled();
    final biometricEmail = session.getBiometricEmail();

    if (!biometricEnabled ||
        biometricEmail == null ||
        biometricEmail.trim().isEmpty) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: "First login with email and password.",
      );
      return;
    }

    if (token == null || token.isEmpty) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: "Session expired. Please login with email and password.",
      );
      return;
    }

    final result = await _getCurrentUserUsecase();

    await result.fold(
      (failure) async {
        await tokenService.removeToken();
        await session.clearLoginSession();

        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.message,
        );
      },
      (user) async {
        await _saveUserToSession(user);

        state = state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
          errorMessage: null,
        );
      },
    );
  }

  Future<void> _saveUserToSession(dynamic user) async {
    final session = ref.read(userSessionServiceProvider);

    final String email = (user.email ?? '').toString().trim();
    final String firstName = (user.firstName ?? '').toString().trim();
    final String lastName = (user.lastName ?? '').toString().trim();
    final String profilePicture = (user.profilePicture ?? '').toString().trim();

    String displayName = '$firstName $lastName'.trim();
    if (displayName.isEmpty) {
      displayName = _getDisplayNameFromEmail(email);
    }

    await session.saveUserSession(
      userId: user.authId?.toString(),
      email: email,
      username: displayName,
      profilePicture: profilePicture.isEmpty ? null : profilePicture,
    );
  }

  String _getDisplayNameFromEmail(String email) {
    if (email.isEmpty) return 'User';
    if (!email.contains('@')) return email;
    return email.split('@').first.trim();
  }
}