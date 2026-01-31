import 'package:equatable/equatable.dart';
import 'package:futal_booking_system/features/profile/domain/entities/profile_entity.dart';


enum ProfileStatus { initial, loading, updated, error, loaded }

class ProfileState extends Equatable {
  final ProfileStatus? status;
  final ProfileEntity? user;
  final String? errorMessage;

  const ProfileState({this.status, this.user, this.errorMessage});

  //copywith
  ProfileState copyWith({
    ProfileStatus? status,
    ProfileEntity? user,
    String? errorMessage,
  }) {
    return ProfileState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, user, errorMessage];
}
