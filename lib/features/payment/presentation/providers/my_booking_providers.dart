import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:futal_booking_system/core/api/api_client.dart';
import 'package:futal_booking_system/features/bookings/data/datsources/remote/booking_remote_datsource.dart';


// ✅ very small Booking model for list page
class BookingItem {
  final String id;
  final String date;
  final String startTime;
  final String endTime;
  final num price;
  final String status;
  final String paymentStatus;

  BookingItem({
    required this.id,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.price,
    required this.status,
    required this.paymentStatus,
  });

  factory BookingItem.fromJson(Map<String, dynamic> j) {
    return BookingItem(
      id: (j["_id"] ?? j["id"]).toString(),
      date: (j["date"] ?? "").toString(),
      startTime: (j["startTime"] ?? "").toString(),
      endTime: (j["endTime"] ?? "").toString(),
      price: (j["price"] ?? 0),
      status: (j["status"] ?? "").toString(),
      paymentStatus: (j["paymentStatus"] ?? "").toString(),
    );
  }
}


final bookingRemoteForListProvider = Provider<BookingRemoteDataSource>((ref) {
  final api = ref.read(apiClientProvider);
  return BookingRemoteDataSource(api);
});


final myBookingsProvider = FutureProvider<List<BookingItem>>((ref) async {
  final ds = ref.read(bookingRemoteForListProvider);
  final res = await ds.getMyBookings();

  if (res["success"] == true) {
    final list = (res["bookings"] as List?) ?? [];
    return list
        .map((e) => BookingItem.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  throw Exception(res["message"]?.toString() ?? "Failed to load bookings");
});

final cancelBookingProvider =
    StateNotifierProvider<CancelBookingNotifier, AsyncValue<void>>((ref) {
  return CancelBookingNotifier(ref);
});

class CancelBookingNotifier extends StateNotifier<AsyncValue<void>> {
  CancelBookingNotifier(this.ref) : super(const AsyncData(null));
  final Ref ref;

  Future<void> cancel(String bookingId) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final ds = ref.read(bookingRemoteForListProvider);
      final res = await ds.cancelBooking(bookingId);

      if (res["success"] != true) {
        throw Exception(res["message"]?.toString() ?? "Cancel failed");
      }

      
      ref.invalidate(myBookingsProvider);
    });
  }
}