import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futal_booking_system/core/error/failure.dart';
import 'package:futal_booking_system/core/services/connectivity/network_info.dart';
import 'package:futal_booking_system/features/profile/data/datasources/profile_datasource.dart';
import 'package:futal_booking_system/features/profile/data/datasources/remote/profile_remote_datasoure.dart';
import 'package:futal_booking_system/features/profile/data/models/profile_model.dart';
import 'package:futal_booking_system/features/profile/domain/entities/profile_entity.dart';
import 'package:futal_booking_system/features/profile/domain/repositories/profile_repository.dart';

final profileRepositoryProvider = Provider<IProfileRepository>((ref) {
  final remote = ref.read(profileRemoteDatasourceProvider); // ✅ this returns ProfileRemoteDatasource
  final networkInfo = ref.read(networkInfoProvider);

  return ProfileRepository(
    profileRemoteDatasource: remote, // ✅ matches IProfileRemoteDatasource
    networkInfo: networkInfo,
  );
});

class ProfileRepository implements IProfileRepository {
  final IProfileRemoteDatasource _profileRemoteDatasource;
  final NetworkInfo _networkInfo;

  ProfileRepository({
    required IProfileRemoteDatasource profileRemoteDatasource,
    required NetworkInfo networkInfo,
  })  : _profileRemoteDatasource = profileRemoteDatasource,
        _networkInfo = networkInfo;

  @override
  Future<Either<Failure, bool>> updateProfile(ProfileEntity updatedData) async {
    if (!await _networkInfo.isConnected) {
      return const Left(
        LocalDatabaseFailure(message: "No internet connection"),
      );
    }

    try {
      // ✅ Avoid fromEntity mismatch problems by mapping directly
      final apiModel = ProfileModel(
        userId: updatedData.userId,
        firstName: updatedData.firstName,
        lastName: updatedData.lastName,
        profile: updatedData.profile, // File?
        profilePicture: updatedData.profilePicture, // String?
      );

      final model = await _profileRemoteDatasource.updatePersonalInfo(apiModel);

      if (model != null) return const Right(true);
      return const Left(ApiFailure(message: "Not updated"));
    } on DioException catch (e) {
      final data = e.response?.data;

      String msg = "Request failed";
      if (data is Map && data["message"] != null) {
        msg = data["message"].toString();
      } else if (data is String) {
        msg = data;
      } else if (e.message != null) {
        msg = e.message!;
      }

      return Left(
        ApiFailure(
          message: msg,
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProfileEntity?>> getUserById(String userId) async {
    if (!await _networkInfo.isConnected) {
      return const Left(
        LocalDatabaseFailure(message: "No internet connection"),
      );
    }

    try {
      final userApiModel = await _profileRemoteDatasource.getUserById(userId);

      if (userApiModel != null) {
        return Right(userApiModel.toEntity());
      }

      return const Left(ApiFailure(message: "User not found"));
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}