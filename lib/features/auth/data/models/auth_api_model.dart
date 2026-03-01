import 'package:futal_booking_system/features/auth/domain/entities/auth_entity.dart';

class AuthApiModel {
  final String? id;
  final String email;
  final String? password;
  final String role;
  final String? profile;

  AuthApiModel({
    this.id,
    required this.email,
    this.password,
    this.role = 'user',
    this.profile,
  });

  // Convert to JSON (used for register)
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'role': role,
    };
  }

  // Create from backend JSON safely
  factory AuthApiModel.fromJson(Map<String, dynamic> json) {
    return AuthApiModel(
      id: json['_id']?.toString(),
      email: json['email']?.toString() ?? '',
      password: json['password']?.toString(),
      role: json['role']?.toString() ?? 'user',
      profile: json['profile']?.toString(),
    );
  }

  AuthEntity toEntity() {
    return AuthEntity(
      authId: id,
      email: email,
      firstName: '',   // since backend doesn't provide
      lastName: '',    // since backend doesn't provide
      password: password,
      profilePicture: profile,
    );
  }

  factory AuthApiModel.fromEntity(AuthEntity entity) {
    return AuthApiModel(
      email: entity.email,
      password: entity.password,
    );
  }
}