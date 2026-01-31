import 'package:futal_booking_system/features/auth/domain/entities/auth_entity.dart';

class AuthApiModel {
  final String? id;

  final String email;
  final String? password;
  final String firstName;
  final String lastName;
  final String role;

  AuthApiModel({
    this.id,

    required this.email,
    this.password,
    required this.firstName,
    required this.lastName,
    this.role = 'user',
  }) {
    // Validation

    if (email.isEmpty || !_isValidEmail(email)) {
      throw ArgumentError('Email must be a valid email address');
    }
    if (password!.length < 6) {
      throw ArgumentError('Password must be at least 6 characters');
    }
    if (role != 'user' && role != 'admin') {
      throw ArgumentError('Role must be either "user" or "admin"');
    }
  }

  // Email validation helper
  static bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    return emailRegex.hasMatch(email);
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,

      'email': email,
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
      'role': role,
    };
  }

  // Create from JSON
  factory AuthApiModel.fromJson(Map<String, dynamic> json) {
    return AuthApiModel(
      id: json['_id'] as String?,
      email: json['email'] as String,
      password: json['password'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      role: json['role'] as String? ?? 'user',
    );
  }
  AuthEntity toEntity() {
    return AuthEntity(
      authId: id,
      email: email,
      firstName: firstName,
      lastName: lastName,
    );
  }

  factory AuthApiModel.fromEntity(AuthEntity entity) {
    return AuthApiModel(
      email: entity.email,
      firstName: entity.firstName,
      lastName: entity.lastName,
      password: entity.password,
    );
  }
}
