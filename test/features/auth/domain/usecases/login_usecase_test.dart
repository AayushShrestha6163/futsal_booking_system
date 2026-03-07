import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:futal_booking_system/core/error/failure.dart';
import 'package:futal_booking_system/features/auth/domain/entities/auth_entity.dart';
import 'package:futal_booking_system/features/auth/domain/repositories/auth_repository.dart';
import 'package:futal_booking_system/features/auth/domain/usecases/login_usecase.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late LoginUsecase usecase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = LoginUsecase(authRepository: mockAuthRepository);
  });

  const loginParams = LoginParams(
    email: 'test@example.com',
    password: 'password123',
  );

  const testUser = AuthEntity(
    authId: '1',
    firstName: 'Test',
    lastName: 'User',
    email: 'test@example.com',
    password: 'password123',
    profilePicture: null,
  );

  test('should call repository.login with correct parameters', () async {
    when(() => mockAuthRepository.login(loginParams.email, loginParams.password))
        .thenAnswer((_) async => const Right(testUser));

    final result = await usecase(loginParams);

    expect(result, const Right(testUser));
    verify(() => mockAuthRepository.login(loginParams.email, loginParams.password)).called(1);
    verifyNoMoreInteractions(mockAuthRepository);
  });

  test('should return Failure when login fails', () async {
    final failure = ApiFailure(message: 'Invalid credentials');

    when(() => mockAuthRepository.login(loginParams.email, loginParams.password))
        .thenAnswer((_) async => Left(failure));

    final result = await usecase(loginParams);

    expect(result, Left(failure));
    verify(() => mockAuthRepository.login(loginParams.email, loginParams.password)).called(1);
  });
}