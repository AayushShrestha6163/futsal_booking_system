import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futal_booking_system/core/error/failure.dart';
import 'package:futal_booking_system/core/usecases/app_usecases.dart';
import 'package:futal_booking_system/features/profile/data/repositories/profile_repository.dart';
import 'package:futal_booking_system/features/profile/domain/entities/profile_entity.dart';
import 'package:futal_booking_system/features/profile/domain/repositories/profile_repository.dart';


class UpdateProfileUsecaseParams extends Equatable {
  final String? firstName;
  final String? lastName; 
  final String? password;
  final File? profile;

  const UpdateProfileUsecaseParams({
    this.firstName,
    this.lastName,
    this.password,
    this.profile, 
  });

  @override
  List<Object?> get props => [
    firstName,
    lastName,
    password,
    profile,
  ];
}

final updateProfileUsecaseProvider = Provider<UpdateProfileUsecase>((ref) {
  final profileRepository = ref.read(profileRepositoryProvider);
  return UpdateProfileUsecase(profileRepository: profileRepository);
});

class UpdateProfileUsecase
    implements UsecaseWithParms<bool, UpdateProfileUsecaseParams> {
  final IProfileRepository _profileRepository;

  UpdateProfileUsecase({required IProfileRepository profileRepository})
    : _profileRepository = profileRepository;

  @override
  Future<Either<Failure, bool>> call(UpdateProfileUsecaseParams params) {
    final profileEntity = ProfileEntity(
      firstName: params.firstName,
      lastName: params.lastName,
      profile: params.profile,
      password: params.password,
    );
    return _profileRepository.updateProfile(profileEntity);
  }
}
