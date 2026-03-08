import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:futal_booking_system/core/error/failure.dart';
import 'package:futal_booking_system/features/auth/domain/entities/auth_entity.dart';
import 'package:futal_booking_system/features/auth/domain/repositories/auth_repository.dart';
import 'package:futal_booking_system/features/auth/domain/usecases/register_usecase.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

class FakeAuthEntity extends Fake implements AuthEntity {}

void main() {
  late RegisterUsecase usecase;
  late MockAuthRepository mockAuthRepository;

  setUpAll(() {
    registerFallbackValue(FakeAuthEntity());
  });

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = RegisterUsecase(authRepository: mockAuthRepository);
  });

  const params = RegisterParams(
    firstName: 'Aayush',
    lastName: 'Shrestha',
    email: 'aayush@example.com',
    password: 'password123',
  );

  test('should call repository.register with correct AuthEntity', () async {
    when(
      () => mockAuthRepository.register(any()),
    ).thenAnswer((_) async => const Right(true));

    final result = await usecase(params);

    expect(result, const Right(true));

    verify(
      () => mockAuthRepository.register(
        const AuthEntity(
          firstName: 'Aayush',
          lastName: 'Shrestha',
          email: 'aayush@example.com',
          password: 'password123',
        ),
      ),
    ).called(1);

    verifyNoMoreInteractions(mockAuthRepository);
  });

  test('should return Failure when register fails', () async {
    final failure = ApiFailure(message: 'Registration failed');

    when(
      () => mockAuthRepository.register(any()),
    ).thenAnswer((_) async => Left(failure));

    final result = await usecase(params);

    expect(result, Left(failure));
    verify(() => mockAuthRepository.register(any())).called(1);
    verifyNoMoreInteractions(mockAuthRepository);
  });
}