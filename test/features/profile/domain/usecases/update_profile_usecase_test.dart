

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:futal_booking_system/core/error/failure.dart';
import 'package:futal_booking_system/features/profile/domain/entities/profile_entity.dart';
import 'package:futal_booking_system/features/profile/domain/repositories/profile_repository.dart';
import 'package:futal_booking_system/features/profile/domain/usecases/update_profile_usecase.dart';

class MockProfileRepository extends Mock implements IProfileRepository {}

void main() {
  late UpdateProfileUsecase usecase;
  late MockProfileRepository mockProfileRepository;

  setUp(() {
    mockProfileRepository = MockProfileRepository();
    usecase = UpdateProfileUsecase(profileRepository: mockProfileRepository);
  });

  const tFirstName = 'Aayush';
  const tLastName = 'Shrestha';
  const tPassword = '123456';

  const params = UpdateProfileUsecaseParams(
    firstName: tFirstName,
    lastName: tLastName,
    password: tPassword,
    profile: null,
  );

  final expectedProfileEntity = ProfileEntity(
    firstName: tFirstName,
    lastName: tLastName,
    password: tPassword,
    profile: null,
  );

  group('UpdateProfileUsecase', () {
    test('should call updateProfile with correct ProfileEntity and return true', () async {
      when(() => mockProfileRepository.updateProfile(expectedProfileEntity))
          .thenAnswer((_) async => const Right(true));

      final result = await usecase(params);

      expect(result, const Right(true));
      verify(() => mockProfileRepository.updateProfile(expectedProfileEntity)).called(1);
      verifyNoMoreInteractions(mockProfileRepository);
    });

    test('should return Failure when repository updateProfile fails', () async {
      final failure = ApiFailure(message: 'Failed to update profile');

      when(() => mockProfileRepository.updateProfile(expectedProfileEntity))
          .thenAnswer((_) async => Left(failure));

      final result = await usecase(params);

      expect(result, Left(failure));
      verify(() => mockProfileRepository.updateProfile(expectedProfileEntity)).called(1);
      verifyNoMoreInteractions(mockProfileRepository);
    });
  });
}