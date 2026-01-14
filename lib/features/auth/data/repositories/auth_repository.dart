import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futal_booking_system/core/error/failure.dart';
import 'package:futal_booking_system/features/auth/data/datasources/auth_datasource.dart';
import 'package:futal_booking_system/features/auth/data/datasources/local/auth_local_datasource.dart';
import 'package:futal_booking_system/features/auth/data/models/auth_hive_model.dart';
import 'package:futal_booking_system/features/auth/domain/entities/auth_entity.dart';
import 'package:futal_booking_system/features/auth/domain/repositories/auth_repository.dart';


//provider

final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  return AuthRepository(authDatasource: ref.read(authLocalDatasourceProvider));
});

class AuthRepository implements IAuthRepository {
  final IAuthDataSource _authDatasource;

  AuthRepository({required IAuthDataSource authDatasource})
    : _authDatasource = authDatasource;
  @override
  // Future<Either<Failure, AuthEntity>> getCurrentUser(String userId) async{
  //   try {
  //     final user = await _authDatasource.getCurrentUser(userId);
  //     if(user != null){
  //       final userEntity = user.toEntity();
  //       return Future.value(Right(userEntity));
  //     }
  //     return Left( LocalDatabaseFailure(message: 'User not found'));
  //   } catch (e) {
  //     return Future.value(Left(LocalDatabaseFailure(message: e.toString())));
  //   }
  // }

  @override
  Future<Either<Failure, AuthEntity>> login(String email, String password) async{
    try {
      final user = await _authDatasource.login(email, password);
      if(user != null){
        final userEntity = user.toEntity();
        return Right(userEntity);
      }
      return Left(LocalDatabaseFailure(message: 'Login failed'));
    } catch (e) {
      return Future.value(Left(LocalDatabaseFailure(message: e.toString())));
    }
  }

  @override
  Future<Either<Failure, bool>> logout() async{
    try {
      final result = await _authDatasource.logout();
      if(result){
        return Right(result);
      }
      return Left(LocalDatabaseFailure(message: 'Logout failed'));
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> register(AuthEntity authEntity) async{
    try {
      final model = AuthHiveModel.fromEntity(authEntity);
      final result = await _authDatasource.register(model);
      if(result){
        return Right(result);
      }
      return Left(LocalDatabaseFailure(message: 'Registration failed'));
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, AuthEntity>> getCurrentUser() {
    // TODO: implement getCurrentUser
    throw UnimplementedError();
  }
}