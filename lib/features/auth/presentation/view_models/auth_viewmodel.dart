import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futal_booking_system/features/auth/domain/usecases/login_usecase.dart';
import 'package:futal_booking_system/features/auth/domain/usecases/register_usecase.dart';
import 'package:futal_booking_system/features/auth/presentation/state/auth_state.dart';

final authViewModelProvider = NotifierProvider<AuthViewModel, AuthState>(
  AuthViewModel.new,
);

class AuthViewModel extends Notifier<AuthState> {
  late final RegisterUsecase _registerUsecase;
  late final LoginUsecase _loginUsecase;
  // late final GetCurrentUserUsecase _getCurrentUserUsecase;
  // late final LogoutUsecase _logoutUsecase;

  @override
  AuthState build() {
    _registerUsecase = ref.read(registerUsecaseProvider);
    _loginUsecase = ref.read(loginUsecaseProvider);
    // _getCurrentUserUsecase = ref.read(getCurrentUserUsecaseProvider);
    // _logoutUsecase = ref.read(logoutUsecaseProvider);
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
      (success) => state = state.copyWith(status: AuthStatus.registered),
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
      (user) =>
          state = state.copyWith(status: AuthStatus.authenticated, user: user),
    );
  }
}
