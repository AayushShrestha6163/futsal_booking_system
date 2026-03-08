import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';

import 'package:futal_booking_system/core/error/failure.dart';
import 'package:futal_booking_system/core/services/storage/token_service.dart';
import 'package:futal_booking_system/core/services/storage/user_session_service.dart';
import 'package:futal_booking_system/features/auth/domain/entities/auth_entity.dart';
import 'package:futal_booking_system/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:futal_booking_system/features/auth/domain/usecases/login_usecase.dart';
import 'package:futal_booking_system/features/auth/domain/usecases/register_usecase.dart';
import 'package:futal_booking_system/features/auth/presentation/state/auth_state.dart';
import 'package:futal_booking_system/features/auth/presentation/view_models/auth_viewmodel.dart';

class MockRegisterUsecase extends Mock implements RegisterUsecase {}

class MockLoginUsecase extends Mock implements LoginUsecase {}

class MockGetCurrentUserUsecase extends Mock implements GetCurrentUserUsecase {}

class MockTokenService extends Mock implements TokenService {}

class MockUserSessionService extends Mock implements UserSessionService {}

class FakeRegisterParams extends Fake implements RegisterParams {}

class FakeLoginParams extends Fake implements LoginParams {}

void main() {
  late ProviderContainer container;
  late MockRegisterUsecase mockRegisterUsecase;
  late MockLoginUsecase mockLoginUsecase;
  late MockGetCurrentUserUsecase mockGetCurrentUserUsecase;
  late MockTokenService mockTokenService;
  late MockUserSessionService mockUserSessionService;

  const testUser = AuthEntity(
    authId: 'u1',
    firstName: 'Aayush',
    lastName: 'Shrestha',
    email: 'aayush@gmail.com',
    password: 'password123',
    profilePicture: null,
  );

  setUpAll(() {
    registerFallbackValue(FakeRegisterParams());
    registerFallbackValue(FakeLoginParams());
  });

  setUp(() {
    mockRegisterUsecase = MockRegisterUsecase();
    mockLoginUsecase = MockLoginUsecase();
    mockGetCurrentUserUsecase = MockGetCurrentUserUsecase();
    mockTokenService = MockTokenService();
    mockUserSessionService = MockUserSessionService();

    when(
      () => mockUserSessionService.saveUserSession(
        userId: any(named: 'userId'),
        email: any(named: 'email'),
        username: any(named: 'username'),
        profilePicture: any(named: 'profilePicture'),
      ),
    ).thenAnswer((_) async {});

    when(
      () => mockUserSessionService.saveBiometricLogin(
        email: any(named: 'email'),
      ),
    ).thenAnswer((_) async {});

    when(() => mockUserSessionService.clearLoginSession())
        .thenAnswer((_) async {});

    container = ProviderContainer(
      overrides: [
        registerUsecaseProvider.overrideWithValue(mockRegisterUsecase),
        loginUsecaseProvider.overrideWithValue(mockLoginUsecase),
        getCurrentUserUsecaseProvider
            .overrideWithValue(mockGetCurrentUserUsecase),
        tokenServiceProvider.overrideWithValue(mockTokenService),
        userSessionServiceProvider.overrideWithValue(mockUserSessionService),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('AuthViewModel', () {
    test('initial state should be AuthState()', () {
      final state = container.read(authViewModelProvider);
      expect(state, const AuthState());
    });

    test('register success -> registered state', () async {
      when(() => mockRegisterUsecase(any()))
          .thenAnswer((_) async => const Right(true));

      final notifier = container.read(authViewModelProvider.notifier);

      await notifier.register(
        firstName: 'Aayush',
        lastName: 'Shrestha',
        email: 'aayush@gmail.com',
        password: 'password123',
      );

      final state = container.read(authViewModelProvider);

      expect(state.status, AuthStatus.registered);
      expect(state.errorMessage, null);
      verify(() => mockRegisterUsecase(any())).called(1);
    });

    test('register failure -> error state', () async {
      final failure = ApiFailure(message: 'Registration failed');

      when(() => mockRegisterUsecase(any()))
          .thenAnswer((_) async => Left(failure));

      final notifier = container.read(authViewModelProvider.notifier);

      await notifier.register(
        firstName: 'Aayush',
        lastName: 'Shrestha',
        email: 'aayush@gmail.com',
        password: 'password123',
      );

      final state = container.read(authViewModelProvider);

      expect(state.status, AuthStatus.error);
      expect(state.errorMessage, 'Registration failed');
      verify(() => mockRegisterUsecase(any())).called(1);
    });

    test('login success -> authenticated state and saves session', () async {
      when(() => mockLoginUsecase(any()))
          .thenAnswer((_) async => const Right(testUser));

      final notifier = container.read(authViewModelProvider.notifier);

      await notifier.login(
        email: 'aayush@gmail.com',
        password: 'password123',
      );

      final state = container.read(authViewModelProvider);

      expect(state.status, AuthStatus.authenticated);
      expect(state.user, testUser);
      expect(state.errorMessage, null);

      verify(() => mockLoginUsecase(any())).called(1);
      verify(
        () => mockUserSessionService.saveUserSession(
          userId: 'u1',
          email: 'aayush@gmail.com',
          username: 'aayush',
          profilePicture: null,
        ),
      ).called(1);
      verify(
        () => mockUserSessionService.saveBiometricLogin(
          email: 'aayush@gmail.com',
        ),
      ).called(1);
    });

    test('login failure -> error state', () async {
      final failure = ApiFailure(message: 'Invalid credentials');

      when(() => mockLoginUsecase(any()))
          .thenAnswer((_) async => Left(failure));

      final notifier = container.read(authViewModelProvider.notifier);

      await notifier.login(
        email: 'aayush@gmail.com',
        password: 'wrongpass',
      );

      final state = container.read(authViewModelProvider);

      expect(state.status, AuthStatus.error);
      expect(state.errorMessage, 'Invalid credentials');
      verify(() => mockLoginUsecase(any())).called(1);
    });

    test('fingerprintLogin -> error when biometric login not enabled',
        () async {
      when(() => mockTokenService.getToken()).thenAnswer((_) async => 'token');
      when(() => mockUserSessionService.isBiometricLoginEnabled())
          .thenReturn(false);
      when(() => mockUserSessionService.getBiometricEmail()).thenReturn(null);

      final notifier = container.read(authViewModelProvider.notifier);

      await notifier.fingerprintLogin();

      final state = container.read(authViewModelProvider);

      expect(state.status, AuthStatus.error);
      expect(state.errorMessage, 'First login with email and password.');
    });

    test('fingerprintLogin -> error when token missing', () async {
      when(() => mockTokenService.getToken()).thenAnswer((_) async => null);
      when(() => mockUserSessionService.isBiometricLoginEnabled())
          .thenReturn(true);
      when(() => mockUserSessionService.getBiometricEmail())
          .thenReturn('aayush@gmail.com');

      final notifier = container.read(authViewModelProvider.notifier);

      await notifier.fingerprintLogin();

      final state = container.read(authViewModelProvider);

      expect(state.status, AuthStatus.error);
      expect(
        state.errorMessage,
        'Session expired. Please login with email and password.',
      );
    });

    test('fingerprintLogin success -> authenticated state', () async {
      when(() => mockTokenService.getToken()).thenAnswer((_) async => 'token');
      when(() => mockUserSessionService.isBiometricLoginEnabled())
          .thenReturn(true);
      when(() => mockUserSessionService.getBiometricEmail())
          .thenReturn('aayush@gmail.com');
      when(() => mockGetCurrentUserUsecase())
          .thenAnswer((_) async => const Right(testUser));

      final notifier = container.read(authViewModelProvider.notifier);

      await notifier.fingerprintLogin();

      final state = container.read(authViewModelProvider);

      expect(state.status, AuthStatus.authenticated);
      expect(state.user, testUser);

      verify(() => mockGetCurrentUserUsecase()).called(1);
      verify(
        () => mockUserSessionService.saveUserSession(
          userId: 'u1',
          email: 'aayush@gmail.com',
          username: 'aayush',
          profilePicture: null,
        ),
      ).called(1);
    });

    test('fingerprintLogin failure -> clears session and token', () async {
      final failure = ApiFailure(message: 'Unauthorized');

      when(() => mockTokenService.getToken()).thenAnswer((_) async => 'token');
      when(() => mockTokenService.removeToken()).thenAnswer((_) async {});
      when(() => mockUserSessionService.isBiometricLoginEnabled())
          .thenReturn(true);
      when(() => mockUserSessionService.getBiometricEmail())
          .thenReturn('aayush@gmail.com');
      when(() => mockGetCurrentUserUsecase())
          .thenAnswer((_) async => Left(failure));

      final notifier = container.read(authViewModelProvider.notifier);

      await notifier.fingerprintLogin();

      final state = container.read(authViewModelProvider);

      expect(state.status, AuthStatus.error);
      expect(state.errorMessage, 'Unauthorized');

      verify(() => mockTokenService.removeToken()).called(1);
      verify(() => mockUserSessionService.clearLoginSession()).called(1);
    });
  });
}