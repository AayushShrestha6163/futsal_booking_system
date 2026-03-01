import 'package:futal_booking_system/core/api/api_client.dart';
import 'package:futal_booking_system/core/api/api_endpoints.dart';

class BookingRemoteDataSource {
  final ApiClient api;
  BookingRemoteDataSource(this.api);

  Future<dynamic> createBooking({
    required String courtId,
    required String date,
    required String startTime,
    required String endTime,
  }) async {
    final res = await api.post(
      ApiEndpoints.bookings,
      data: {
        "court": courtId,
        "date": date,
        "startTime": startTime,
        "endTime": endTime,
      },
    );
    return res.data;
  }

  Future<dynamic> getMyBookings() async {
    final res = await api.get(ApiEndpoints.myBookings);
    return res.data;
  }

  Future<dynamic> cancelBooking(String bookingId) async {
    final res = await api.delete(ApiEndpoints.cancelBooking(bookingId));
    return res.data;
  }
}