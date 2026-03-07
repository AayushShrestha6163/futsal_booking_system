import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:futal_booking_system/features/courts/domain/entities/court_entity.dart';
import 'package:futal_booking_system/features/courts/domain/repositories/court_repositorty.dart';
import 'package:futal_booking_system/features/courts/domain/usecases/get_court_by_id_usecase.dart';

class MockCourtRepository extends Mock implements CourtRepository {}

void main() {
  late GetCourtByIdUsecase usecase;
  late MockCourtRepository mockRepo;

  setUp(() {
    mockRepo = MockCourtRepository();
    usecase = GetCourtByIdUsecase(mockRepo);
  });

  const testCourt = CourtEntity(
    id: 'court123',
    name: 'City Futsal',
    location: 'Kathmandu',
    pricePerHour: 2000,
    image: 'court.png',
  );

  test('should return court when repository call is successful', () async {
    when(() => mockRepo.getCourtById('court123'))
        .thenAnswer((_) async => testCourt);

    final result = await usecase('court123');

    expect(result, testCourt);
    verify(() => mockRepo.getCourtById('court123')).called(1);
    verifyNoMoreInteractions(mockRepo);
  });
}