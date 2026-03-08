import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:futal_booking_system/features/payment/presentation/providers/booking_stats_provider.dart';
import 'package:futal_booking_system/features/payment/presentation/providers/my_booking_providers.dart';

void main() {
  group('BookingItem.fromJson', () {
    test('should map json correctly', () {
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

      expect(item.id, "b1");
      expect(item.date, "2026-03-07");
      expect(item.startTime, "10:00");
      expect(item.endTime, "11:30");
      expect(item.price, 1500);
      expect(item.status, "confirmed");
      expect(item.paymentStatus, "paid");
    });

    test('should support id when _id is missing', () {
      final json = {
        "id": "b2",
        "date": "2026-03-08",
        "startTime": "12:00",
        "endTime": "13:00",
        "price": 1000,
        "status": "pending",
        "paymentStatus": "unpaid",
      };

      final item = BookingItem.fromJson(json);

      expect(item.id, "b2");
      expect(item.status, "pending");
      expect(item.paymentStatus, "unpaid");
    });
  });

 

    test('hoursPlayedProvider should calculate total hours', () async {
      final container = ProviderContainer(
        overrides: [
          myBookingsProvider.overrideWith((ref) async => [
                BookingItem(
                  id: '1',
                  date: '2026-03-07',
                  startTime: '10:00',
                  endTime: '11:00',
                  price: 1000,
                  status: 'confirmed',
                  paymentStatus: 'paid',
                ),
                BookingItem(
                  id: '2',
                  date: '2026-03-08',
                  startTime: '12:00',
                  endTime: '13:30',
                  price: 1500,
                  status: 'confirmed',
                  paymentStatus: 'paid',
                ),
              ]),
        ],
      );

      await container.read(myBookingsProvider.future);

      expect(container.read(hoursPlayedProvider), '2.5');

      container.dispose();
    });

    test('hoursPlayedProvider should return - when no bookings', () async {
      final container = ProviderContainer(
        overrides: [
          myBookingsProvider.overrideWith((ref) async => []),
        ],
      );

      await container.read(myBookingsProvider.future);

      expect(container.read(hoursPlayedProvider), '-');

      container.dispose();
    });

    test('hoursPlayedProvider should ignore invalid time values', () async {
      final container = ProviderContainer(
        overrides: [
          myBookingsProvider.overrideWith((ref) async => [
                BookingItem(
                  id: '1',
                  date: '2026-03-07',
                  startTime: 'invalid',
                  endTime: '11:00',
                  price: 1000,
                  status: 'confirmed',
                  paymentStatus: 'paid',
                ),
              ]),
        ],
      );

      await container.read(myBookingsProvider.future);

      expect(container.read(hoursPlayedProvider), '-');

      container.dispose();
    });

}