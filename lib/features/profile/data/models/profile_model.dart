import 'dart:io';

import 'package:futal_booking_system/features/profile/domain/entities/profile_entity.dart';

class ProfileModel {
  final String? userId;
  final String? firstName;
  final String? lastName;
  final File? profile;
  final String? password;
  final String? profilePicture;

  ProfileModel({
    this.userId,
    this.firstName,
    this.lastName,
    this.profile,
    this.password,
    this.profilePicture,
  }) {
    // Validation
    if (password != null && password!.length < 6) {
      throw ArgumentError('Password must be at least 6 characters');
    }
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    if (userId != null) json['_id'] = userId;
    if (firstName != null) json['firstName'] = firstName;
    if (lastName != null) json['lastName'] = lastName;
    if (profilePicture != null) json['profile'] = profilePicture;
    if (password != null) json['password'] = password;
    return json;
  }

  // Create from JSON
  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      profilePicture: json['profile'] as String?,
      password: json['password'] as String?,
    );
  }

  ProfileEntity toEntity() {
    return ProfileEntity(
      userId: userId,
      firstName: firstName,
      lastName: lastName,
      profile: profile,
      profilePicture: profilePicture,
    );
  }

  factory ProfileModel.fromEntity(ProfileEntity entity) {
    return ProfileModel(
      
      firstName: entity.firstName,
      lastName: entity.lastName,
      profile: entity.profile,
      profilePicture: entity.profilePicture,
    );
  }
}
