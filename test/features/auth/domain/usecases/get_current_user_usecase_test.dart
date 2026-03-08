import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:futal_booking_system/core/error/failure.dart';
import 'package:futal_booking_system/features/auth/domain/entities/auth_entity.dart';
import 'package:futal_booking_system/features/auth/domain/repositories/auth_repository.dart';
import 'package:futal_booking_system/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late GetCurrentUserUsecase usecase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = GetCurrentUserUsecase(mockAuthRepository);
  });

  const testUser = AuthEntity(
    authId: '1',
    firstName: 'Aayush',
    lastName: 'Shrestha',
    email: 'aayush@example.com',
    password: '123456',
    profilePicture: 'profile.png',
  );

  test('should return current user when repository call is successful', () async {
    when(() => mockAuthRepository.getCurrentUser())
        .thenAnswer((_) async => const Right(testUser));

    final result = await usecase();

    expect(result, const Right(testUser));
    verify(() => mockAuthRepository.getCurrentUser()).called(1);
    verifyNoMoreInteractions(mockAuthRepository);
  });

  test('should return Failure when repository call is unsuccessful', () async {
    final failure = ApiFailure(message: 'User not found');

    when(() => mockAuthRepository.getCurrentUser())
        .thenAnswer((_) async => Left(failure));

    final result = await usecase();

    expect(result, Left(failure));
    verify(() => mockAuthRepository.getCurrentUser()).called(1);
    verifyNoMoreInteractions(mockAuthRepository);
  });
}