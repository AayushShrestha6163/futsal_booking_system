import 'package:futal_booking_system/core/api/api_client.dart';
import 'package:futal_booking_system/core/api/api_endpoints.dart';

class SlotRemoteDataSource {
  final ApiClient api;
  SlotRemoteDataSource(this.api);

  Future<dynamic> getSlots(String courtId, String date) async {
    final res = await api.get(
      ApiEndpoints.courtSlots(courtId),
      queryParameters: {"date": date},
    );
    return res.data;
  }
}