import 'package:futal_booking_system/core/api/api_client.dart';
import 'package:futal_booking_system/core/api/api_endpoints.dart';

class CourtRemoteDataSource {
  final ApiClient apiClient;
  CourtRemoteDataSource(this.apiClient);

  Future<dynamic> getAllCourts() async {
    final res = await apiClient.get(ApiEndpoints.courts);
    return res.data;
  }

  Future<dynamic> getCourtById(String id) async {
    final res = await apiClient.get(ApiEndpoints.courtById(id));
    return res.data;
  }
}