import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:futal_booking_system/features/bookings/data/datsources/remote/booking_remote_datsource.dart';
import 'package:futal_booking_system/features/payment/presentation/providers/my_booking_providers.dart';

class MockBookingRemoteDataSource extends Mock
    implements BookingRemoteDataSource {}

void main() {
  late ProviderContainer container;
  late MockBookingRemoteDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockBookingRemoteDataSource();

    container = ProviderContainer(
      overrides: [
        bookingRemoteForListProvider.overrideWithValue(mockDataSource),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  test('should return booking list when API success is true', () async {
    when(() => mockDataSource.getMyBookings()).thenAnswer(
      (_) async => {
        "success": true,
        "bookings": [
          {
            "_id": "b1",
            "date": "2026-03-07",
            "startTime": "10:00",
            "endTime": "11:00",
            "price": 1000,
            "status": "confirmed",
            "paymentStatus": "paid",
          },
          {
            "_id": "b2",
            "date": "2026-03-08",
            "startTime": "12:00",
            "endTime": "13:30",
            "price": 1500,
            "status": "pending",
            "paymentStatus": "unpaid",
          },
        ],
      },
    );

    final result = await container.read(myBookingsProvider.future);

    expect(result.length, 2);
    expect(result[0].id, 'b1');
    expect(result[0].date, '2026-03-07');
    expect(result[0].startTime, '10:00');
    expect(result[0].endTime, '11:00');
    expect(result[0].price, 1000);
    expect(result[0].status, 'confirmed');
    expect(result[0].paymentStatus, 'paid');

    expect(result[1].id, 'b2');
    expect(result[1].status, 'pending');
    expect(result[1].paymentStatus, 'unpaid');

    verify(() => mockDataSource.getMyBookings()).called(1);
  });

  test('should return empty list when bookings is empty', () async {
    when(
      () => mockDataSource.getMyBookings(),
    ).thenAnswer((_) async => {"success": true, "bookings": []});

    final result = await container.read(myBookingsProvider.future);

    expect(result, isEmpty);
    verify(() => mockDataSource.getMyBookings()).called(1);
  });

  group('cancelBookingProvider', () {
    test('should cancel booking successfully', () async {
      when(() => mockDataSource.cancelBooking('b1')).thenAnswer(
        (_) async => {"success": true, "message": "Booking cancelled"},
      );

      final notifier = container.read(cancelBookingProvider.notifier);

      await notifier.cancel('b1');

      final state = container.read(cancelBookingProvider);

      expect(state, const AsyncData<void>(null));
      verify(() => mockDataSource.cancelBooking('b1')).called(1);
    });

    test('should return AsyncError when cancel fails', () async {
      when(
        () => mockDataSource.cancelBooking('b1'),
      ).thenAnswer((_) async => {"success": false, "message": "Cancel failed"});

      final notifier = container.read(cancelBookingProvider.notifier);

      await notifier.cancel('b1');

      final state = container.read(cancelBookingProvider);

      expect(state.hasError, true);
      expect(state, isA<AsyncError<void>>());
      verify(() => mockDataSource.cancelBooking('b1')).called(1);
    });
  });

  group('BookingItem.fromJson', () {
    test('should map all fields correctly', () {
      final json = {
        "_id": "b1",
        "date": "2026-03-07",
        "startTime": "10:00",
        "endTime": "11:30",
        "price": 1500,
        "status": "confirmed",
        "paymentStatus": "paid",
      };

      final item = BookingItem.fromJson(json);

      expect(item.id, 'b1');
      expect(item.date, '2026-03-07');
      expect(item.startTime, '10:00');
      expect(item.endTime, '11:30');
      expect(item.price, 1500);
      expect(item.status, 'confirmed');
      expect(item.paymentStatus, 'paid');
    });

    test('should support id when _id is missing', () {
      final json = {
        "id": "b2",
        "date": "2026-03-08",
        "startTime": "12:00",
        "endTime": "13:00",
        "price": 900,
        "status": "pending",
        "paymentStatus": "unpaid",
      };

      final item = BookingItem.fromJson(json);

      expect(item.id, 'b2');
      expect(item.date, '2026-03-08');
      expect(item.status, 'pending');
      expect(item.paymentStatus, 'unpaid');
    });
  });
}
