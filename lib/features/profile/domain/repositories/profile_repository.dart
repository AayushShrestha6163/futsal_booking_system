import 'package:dartz/dartz.dart';
import 'package:futal_booking_system/core/error/failure.dart';
import 'package:futal_booking_system/features/profile/domain/entities/profile_entity.dart';

abstract interface class IProfileRepository {
  Future<Either<Failure, bool>> updateProfile(ProfileEntity updatedData);
  Future<Either<Failure, ProfileEntity?>> getUserById(String userId);
}