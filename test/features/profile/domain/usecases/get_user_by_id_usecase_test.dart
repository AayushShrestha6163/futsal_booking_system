import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:futal_booking_system/core/error/failure.dart';
import 'package:futal_booking_system/features/profile/domain/entities/profile_entity.dart';
import 'package:futal_booking_system/features/profile/domain/repositories/profile_repository.dart';
import 'package:futal_booking_system/features/profile/domain/usecases/get_user_by_id_usecase.dart';

class MockProfileRepository extends Mock implements IProfileRepository {}

void main() {
  late GetUserByIdUsecase usecase;
  late MockProfileRepository mockProfileRepository;

  setUp(() {
    mockProfileRepository = MockProfileRepository();
    usecase = GetUserByIdUsecase(profileRepository: mockProfileRepository);
  });

  const testUserId = '123';

  final testProfile = ProfileEntity(
    userId: testUserId,
    firstName: 'Aayush',
    lastName: 'Shrestha',
    profilePicture: 'profile.jpg',
  );

  final params = GetUserByIdUsecaseParams(userId: testUserId);

  group('GetUserByIdUsecase', () {
    test('should return ProfileEntity when repository call is successful', () async {

      when(() => mockProfileRepository.getUserById(testUserId))
          .thenAnswer((_) async => Right(testProfile));

      final result = await usecase(params);

      expect(result, Right(testProfile));
      verify(() => mockProfileRepository.getUserById(testUserId)).called(1);
      verifyNoMoreInteractions(mockProfileRepository);
    });

    test('should return Failure when repository call fails', () async {

      final failure = ApiFailure(message: "User not found");

      when(() => mockProfileRepository.getUserById(testUserId))
          .thenAnswer((_) async => Left(failure));

      final result = await usecase(params);

      expect(result, Left(failure));
      verify(() => mockProfileRepository.getUserById(testUserId)).called(1);
      verifyNoMoreInteractions(mockProfileRepository);
    });
  });
}