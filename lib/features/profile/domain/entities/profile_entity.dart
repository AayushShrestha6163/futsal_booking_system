import 'dart:io';

import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
  final String? userId;
  final String? firstName;
  final String? lastName;
  final File? profile;
  final String? profilePicture;
  final String? password;

  const ProfileEntity({
    this.userId,
    this.firstName,
    this.lastName,
    this.profile,
    this.profilePicture,
    this.password,  
  });

  @override
  List<Object?> get props => [
    userId,
    firstName,
    lastName,
    profile,
    profilePicture,
    password
  ];
}
