import 'package:flutter_test/flutter_test.dart';
import 'package:futal_booking_system/features/auth/data/models/auth_api_model.dart';
import 'package:futal_booking_system/features/auth/domain/entities/auth_entity.dart';

void main() {
  test('fromJson and toJson should map fields and id/_id correctly', () {
    final json = {
      '_id': 'abc123',
      'email': 'jane.doe@example.com',
      'password': 'secret123',
      'firstName': 'Jane',
      'lastName': 'Doe',
      'role': 'admin',
    };

    final model = AuthApiModel.fromJson(json);

    expect(model.id, 'abc123');
    expect(model.email, 'jane.doe@example.com');
    expect(model.password, 'secret123');
    expect(model.firstName, 'Jane');
    expect(model.lastName, 'Doe');
    expect(model.role, 'admin');

    final out = model.toJson();
    expect(out['id'], 'abc123');
    expect(out['email'], model.email);
    expect(out['password'], model.password);
    expect(out['firstName'], model.firstName);
    expect(out['lastName'], model.lastName);
    expect(out['role'], model.role);
  });

  test('fromJson should default role to "user" when missing', () {
    final json = {
      '_id': 'no-role',
      'email': 'user@example.com',
      'password': 'password1',
      'firstName': 'User',
      'lastName': 'Example',
      // role omitted
    };

    final model = AuthApiModel.fromJson(json);

    expect(model.role, 'user');
  });

  test('constructor throws ArgumentError for invalid email', () {
    expect(
      () => AuthApiModel(
        email: 'invalid-email',
        password: 'goodpass',
        firstName: 'Bad',
        lastName: 'Email',
      ),
      throwsA(isA<ArgumentError>()),
    );
  });

  test('constructor throws ArgumentError for short password', () {
    expect(
      () => AuthApiModel(
        email: 'ok@example.com',
        password: '123', // too short
        firstName: 'Short',
        lastName: 'Pass',
      ),
      throwsA(isA<ArgumentError>()),
    );
  });

  test('fromEntity and toEntity should preserve main fields', () {
    final entity = AuthEntity(
      firstName: 'Ent',
      lastName: 'Ity',
      email: 'ent@example.com',
      password: 'entityPass',
    );

    final model = AuthApiModel.fromEntity(entity);
    final back = model.toEntity();

    expect(back.email, entity.email);
    expect(back.firstName, entity.firstName);
    expect(back.lastName, entity.lastName);
    // authId comes from model.id which was null for fromEntity
    expect(back.authId, null);
  });
}
