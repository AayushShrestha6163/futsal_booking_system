import 'package:futal_booking_system/core/api/api_client.dart';
import 'package:futal_booking_system/core/api/api_endpoints.dart';

class PaymentRemoteDataSource {
  final ApiClient api;
  PaymentRemoteDataSource(this.api);

  Future<dynamic> initiateEsewa(String bookingId) async {
    final res = await api.post(
      ApiEndpoints.initiateEsewa,
      data: {"bookingId": bookingId},
    );
    return res.data;
  }
}