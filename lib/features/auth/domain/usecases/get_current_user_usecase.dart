import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futal_booking_system/core/error/failure.dart';
import 'package:futal_booking_system/features/auth/data/repositories/auth_repository.dart';
import 'package:futal_booking_system/features/auth/domain/entities/auth_entity.dart';
import 'package:futal_booking_system/features/auth/domain/repositories/auth_repository.dart';

final getCurrentUserUsecaseProvider = Provider<GetCurrentUserUsecase>((ref) {
  return GetCurrentUserUsecase(ref.read(authRepositoryProvider));
});

class GetCurrentUserUsecase {
  final IAuthRepository _repo;

  GetCurrentUserUsecase(this._repo);

  Future<Either<Failure, AuthEntity>> call() {
    return _repo.getCurrentUser(); // ✅ token-based current user
  }
}