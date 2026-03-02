import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futal_booking_system/core/services/storage/token_service.dart';
import 'package:futal_booking_system/core/services/storage/user_session_service.dart';
import 'package:futal_booking_system/features/auth/domain/usecases/get_current_user_usecase.dart'; // ✅ ADD THIS
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
    _getCurrentUserUsecase = ref.read(getCurrentUserUsecaseProvider); // ✅ make sure provider name matches
    return const AuthState();
  }

  Future<void> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    state = state.copyWith(status: AuthStatus.loading);

    final result = await _registerUsecase(
      RegisterParams(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
      ),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: failure.message,
      ),
      (_) => state = state.copyWith(status: AuthStatus.registered),
    );
  }

  Future<void> login({required String email, required String password}) async {
    state = state.copyWith(status: AuthStatus.loading);

    final result = await _loginUsecase(
      LoginParams(email: email, password: password),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: failure.message,
      ),
      (user) => state = state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
      ),
    );
  }

  Future<void> fingerprintLogin() async {
    state = state.copyWith(status: AuthStatus.loading);

    final token = await ref.read(tokenServiceProvider).getToken();
    final loggedIn = ref.read(userSessionServiceProvider).isLoggedIn();

    if (token == null || token.isEmpty || !loggedIn) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: "Login once with email/password first.",
      );
      return;
    }

    final result = await _getCurrentUserUsecase();

    result.fold(
      (failure) async {
        await ref.read(tokenServiceProvider).removeToken();
        await ref.read(userSessionServiceProvider).clearSession();

        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.message,
        );
      },
      (user) {
        state = state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
        );
      },
    );
  }
}