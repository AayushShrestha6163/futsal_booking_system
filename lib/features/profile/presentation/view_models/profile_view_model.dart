import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futal_booking_system/core/services/storage/user_session_service.dart';
import 'package:futal_booking_system/features/profile/domain/usecases/get_user_by_id_usecase.dart';
import 'package:futal_booking_system/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:futal_booking_system/features/profile/presentation/state/profile_state.dart';

final profileViewModelProvider =
    NotifierProvider<ProfileViewModel, ProfileState>(() => ProfileViewModel());

class ProfileViewModel extends Notifier<ProfileState> {
  late final UpdateProfileUsecase _updateProfileUsecase;
  late final GetUserByIdUsecase _getUserByIdUsecase;

  @override
  ProfileState build() {
    _updateProfileUsecase = ref.read(updateProfileUsecaseProvider);
    _getUserByIdUsecase = ref.read(getUserByIdUsecaseProvider);
    return ProfileState();
  }

  Future<void> updateProfile({
    String? firstName,
    String? lastName,
    String? password,
    File? profile,
  }) async {
    state = state.copyWith(status: ProfileStatus.loading);

    final params = UpdateProfileUsecaseParams(
      firstName: firstName,
      lastName: lastName,
      password: password,
      profile: profile,
    );

    final result = await _updateProfileUsecase(params);

    await result.fold(
      (failure) async {
        state = state.copyWith(
          status: ProfileStatus.error,
          errorMessage: failure.message,
        );
      },
      (isUpdated) async {
        if (!isUpdated) {
          state = state.copyWith(
            status: ProfileStatus.error,
            errorMessage: "Profile update failed",
          );
          return;
        }

        final session = ref.read(userSessionServiceProvider);
        final userId = session.getCurrentUserId();

        if (userId == null || userId.isEmpty) {
          state = state.copyWith(status: ProfileStatus.updated);
          return;
        }

        final refreshedResult = await _getUserByIdUsecase(
          GetUserByIdUsecaseParams(userId: userId),
        );

        await refreshedResult.fold(
          (failure) async {
            state = state.copyWith(
              status: ProfileStatus.error,
              errorMessage: failure.message,
            );
          },
          (user) async {
            if (user == null) {
              state = state.copyWith(
                status: ProfileStatus.error,
                errorMessage: "Updated user not found",
              );
              return;
            }

            final fullName =
                '${user.firstName ?? ''} ${user.lastName ?? ''}'.trim();

            await session.saveUserSession(
              userId: userId,
              email: session.getCurrentUserEmail(),
              username: fullName.isEmpty ? 'User' : fullName,
              phoneNumber: session.getCurrentUserPhoneNumber(),
              batchId: session.getCurrentUserBatchId(),
              profilePicture: user.profilePicture,
            );

            state = state.copyWith(
              status: ProfileStatus.updated,
              user: user,
            );
          },
        );
      },
    );
  }

  Future<void> getProfileById({required String userId}) async {
    state = state.copyWith(status: ProfileStatus.loading);

    final params = GetUserByIdUsecaseParams(userId: userId);
    final result = await _getUserByIdUsecase(params);

    result.fold(
      (failure) {
        state = state.copyWith(
          status: ProfileStatus.error,
          errorMessage: failure.message,
        );
      },
      (user) {
        if (user != null) {
          state = state.copyWith(
            status: ProfileStatus.loaded,
            user: user,
          );
        } else {
          state = state.copyWith(
            status: ProfileStatus.error,
            errorMessage: "User not found",
          );
        }
      },
    );
  }
}