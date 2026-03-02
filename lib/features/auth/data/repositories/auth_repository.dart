import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futal_booking_system/core/error/failure.dart';
import 'package:futal_booking_system/core/services/connectivity/network_info.dart';
import 'package:futal_booking_system/features/auth/data/datasources/auth_datasource.dart';
import 'package:futal_booking_system/features/auth/data/datasources/local/auth_local_datasource.dart';
import 'package:futal_booking_system/features/auth/data/datasources/remote/auth_remote_datasource.dart';
import 'package:futal_booking_system/features/auth/data/models/auth_api_model.dart';
import 'package:futal_booking_system/features/auth/data/models/auth_hive_model.dart';
import 'package:futal_booking_system/features/auth/domain/entities/auth_entity.dart';
import 'package:futal_booking_system/features/auth/domain/repositories/auth_repository.dart';

// provider
final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  final authDataSource = ref.read(authLocalDatasourceProvider);
  final authRemoteDataSource = ref.read(authRemoteDatasourceProvider);
  final networkInfo = ref.read(networkInfoProvider);

  return AuthRepository(
    authLocalDatasource: authDataSource,
    authRemoteDatasource: authRemoteDataSource,
    networkInfo: networkInfo,
  );
});

class AuthRepository implements IAuthRepository {
  final IAuthLocalDataSource _authDatasource;
  final IAuthRemoteDataSource _authRemoteDatasource;
  final NetworkInfo _networkInfo;

  AuthRepository({
    required IAuthLocalDataSource authLocalDatasource,
    required IAuthRemoteDataSource authRemoteDatasource,
    required NetworkInfo networkInfo,
  }) : _authDatasource = authLocalDatasource,
       _authRemoteDatasource = authRemoteDatasource,
       _networkInfo = networkInfo;

  // ✅ Local DB: get user by id (offline use)
  @override
  Future<Either<Failure, AuthEntity>> getUserById(String userId) async {
    try {
      final user = await _authDatasource.getCurrentUser(userId);
      if (user != null) {
        final entity = user.toEntity(); // ✅ fixed variable name
        return Right(entity);
      }
      return Left(LocalDatabaseFailure(message: 'User not found'));
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  // ✅ Remote: get current user using saved token (for fingerprint login)
  @override
  Future<Either<Failure, AuthEntity>> getCurrentUser() async {
    if (await _networkInfo.isConnected) {
      try {
        final apiModel = await _authRemoteDatasource.getCurrentUser();

        if (apiModel != null) {
          final entity = apiModel.toEntity();
          return Right(entity);
        }

        return const Left(
          ApiFailure(message: "Session expired. Please login again."),
        );
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            message: e.response?.data['message'] ?? 'Failed to get current user',
            statusCode: e.response?.statusCode,
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return const Left(
        ApiFailure(message: "No internet. Please connect and try again."),
      );
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> login(String email, String password) async {
    if (await _networkInfo.isConnected) {
      try {
        final apiModel = await _authRemoteDatasource.login(email, password);
        if (apiModel != null) {
          final entity = apiModel.toEntity();
          return Right(entity);
        }
        return const Left(ApiFailure(message: "Invalid credentials"));
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
      try {
        final model = await _authDatasource.login(email, password);
        if (model != null) {
          final entity = model.toEntity();
          return Right(entity);
        }
        return const Left(
          LocalDatabaseFailure(message: "Invalid email or password"),
        );
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, bool>> logout() async {
    try {
      final result = await _authDatasource.logout();
      if (result) {
        return Right(result);
      }
      return Left(LocalDatabaseFailure(message: 'Logout failed'));
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> register(AuthEntity authEntity) async {
    if (await _networkInfo.isConnected) {
      try {
        final apiModel = AuthApiModel.fromEntity(authEntity);
        await _authRemoteDatasource.register(apiModel);
        return const Right(true);
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            message: e.response?.data['message'] ?? 'Registration failed',
            statusCode: e.response?.statusCode,
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final authModel = AuthHiveModel(
          firstName: authEntity.firstName,
          lastName: authEntity.lastName,
          email: authEntity.email,
          password: authEntity.password,
        );
        await _authDatasource.register(authModel);
        return const Right(true);
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }
}