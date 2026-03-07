import 'package:flutter_test/flutter_test.dart';
import 'package:futal_booking_system/features/courts/domain/usecases/get_all_courts_usecases.dart';
import 'package:mocktail/mocktail.dart';

import 'package:futal_booking_system/features/courts/domain/entities/court_entity.dart';
import 'package:futal_booking_system/features/courts/domain/repositories/court_repositorty.dart';


class MockCourtRepository extends Mock implements CourtRepository {}

void main() {
  late GetAllCourtsUsecase usecase;
  late MockCourtRepository mockRepo;

  setUp(() {
    mockRepo = MockCourtRepository();
    usecase = GetAllCourtsUsecase(mockRepo);
  });

  final testCourts = [
    const CourtEntity(
      id: '1',
      name: 'City Futsal',
      location: 'Kathmandu',
      pricePerHour: 2000,
      image: 'court1.png',
    ),
    const CourtEntity(
      id: '2',
      name: 'Arena Futsal',
      location: 'Lalitpur',
      pricePerHour: 2500,
      image: 'court2.png',
    ),
  ];

  test('should return list of courts from repository', () async {
    when(() => mockRepo.getAllCourts())
        .thenAnswer((_) async => testCourts);

    final result = await usecase();

    expect(result, testCourts);
    verify(() => mockRepo.getAllCourts()).called(1);
    verifyNoMoreInteractions(mockRepo);
  });
}