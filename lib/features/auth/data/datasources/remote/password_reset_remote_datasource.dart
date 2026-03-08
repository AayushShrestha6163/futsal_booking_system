import 'package:dio/dio.dart';
import 'package:futal_booking_system/core/api/api_endpoints.dart';

class PasswordResetRemoteDS {
  final Dio dio;

  PasswordResetRemoteDS(this.dio);

  Future<void> requestPasswordReset(String email) async {
    await dio.post(ApiEndpoints.requestPasswordReset, data: {"email": email});
  }

  Future<void> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    await dio.post(
      ApiEndpoints.resetPassword(Uri.encodeComponent(token)),
      data: {"newPassword": newPassword},
    );
  }
}
