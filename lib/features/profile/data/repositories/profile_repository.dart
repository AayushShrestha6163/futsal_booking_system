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
  final profileRemoteDatasource = ref.read(profileRemoteDatasourceProvider);
  final networkInfo = ref.read(networkInfoProvider);
  return ProfileRepository(
    profileRemoteDatasource: profileRemoteDatasource,
    networkInfo: networkInfo,
  );
});

class ProfileRepository implements IProfileRepository {
  final IProfileRemoteDatasource _profileRemoteDatasource;
  final NetworkInfo _networkInfo;

  ProfileRepository({
    required IProfileRemoteDatasource profileRemoteDatasource,
    required NetworkInfo networkInfo,
  }) : _profileRemoteDatasource = profileRemoteDatasource,
       _networkInfo = networkInfo;

  @override
  Future<Either<Failure, bool>> updateProfile(ProfileEntity updatedData) async {
    if (await _networkInfo.isConnected) {
      try {
        final apiModel = ProfileModel.fromEntity(updatedData);
        final model = await _profileRemoteDatasource.updatePersonalInfo(
          apiModel,
        );
        if (model != null) {
          return Right(true);
        }
        return const Left(ApiFailure(message: "Not updated"));
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            message: e.response?.data['message'] ?? 'Login failed',
            statusCode: e.response?.statusCode,
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
     return Left(
            LocalDatabaseFailure(
              message: "Local Database not supported",
            ),
          );
    }
  }

  @override
  Future<Either<Failure, ProfileEntity?>> getUserById(String userId) async {
    if (await _networkInfo.isConnected) {
      try {
        final userApiModel = await _profileRemoteDatasource.getUserById(userId);
        if (userApiModel != null) {
          final userEntity = userApiModel.toEntity();
          return Right(userEntity);
        } else {
          return const Left(ApiFailure(message: "User not found"));
        }
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
     return Left(
            LocalDatabaseFailure(
              message: "Local Database not supported",
            ),
          );
    }
  }
}
