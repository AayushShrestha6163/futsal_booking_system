import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futal_booking_system/core/error/failure.dart';
import 'package:futal_booking_system/core/usecases/app_usecases.dart';
import 'package:futal_booking_system/features/profile/data/repositories/profile_repository.dart';
import 'package:futal_booking_system/features/profile/domain/entities/profile_entity.dart';
import 'package:futal_booking_system/features/profile/domain/repositories/profile_repository.dart';


class GetUserByIdUsecaseParams extends Equatable {
  final String userId;

  const GetUserByIdUsecaseParams({required this.userId});

  @override
  List<Object?> get props => [userId];
}

final getUserByIdUsecaseProvider = Provider<GetUserByIdUsecase>((ref) {
  final profileRepository = ref.read(profileRepositoryProvider);
  return GetUserByIdUsecase(profileRepository: profileRepository);
});

class GetUserByIdUsecase
    implements UsecaseWithParms<ProfileEntity?, GetUserByIdUsecaseParams> {
  final IProfileRepository _profileRepository;

  GetUserByIdUsecase({required IProfileRepository profileRepository})
    : _profileRepository = profileRepository;

  @override
  Future<Either<Failure, ProfileEntity?>> call(GetUserByIdUsecaseParams params) {
    return _profileRepository.getUserById(params.userId);
  }
}
