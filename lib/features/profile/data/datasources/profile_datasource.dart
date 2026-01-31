
import 'package:futal_booking_system/features/profile/data/models/profile_model.dart';

abstract interface class IProfileRemoteDatasource {
  Future<ProfileModel?> updatePersonalInfo(ProfileModel personalInfo);
  Future<ProfileModel?> getUserById(String userId);
}