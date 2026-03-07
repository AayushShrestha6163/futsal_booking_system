import 'package:flutter_test/flutter_test.dart';
import 'package:futal_booking_system/features/auth/data/models/auth_api_model.dart';
import 'package:futal_booking_system/features/auth/domain/entities/auth_entity.dart';

void main() {
  test('fromJson and toJson should map fields correctly', () {
    final json = {
      '_id': 'abc123',
      'email': 'jane.doe@example.com',
      'password': 'secret123',
      'role': 'admin',
      'profile': 'profile.png',
    };

    final model = AuthApiModel.fromJson(json);

    expect(model.id, 'abc123');
    expect(model.email, 'jane.doe@example.com');
    expect(model.password, 'secret123');
    expect(model.role, 'admin');
    expect(model.profile, 'profile.png');

    final out = model.toJson();
    expect(out['email'], 'jane.doe@example.com');
    expect(out['password'], 'secret123');
    expect(out['role'], 'admin');
  });

  test('fromJson should default role to "user" when missing', () {
    final json = {
      '_id': 'no-role',
      'email': 'user@example.com',
      'password': 'password1',
    };

    final model = AuthApiModel.fromJson(json);

    expect(model.id, 'no-role');
    expect(model.email, 'user@example.com');
    expect(model.password, 'password1');
    expect(model.role, 'user');
  });

  test('fromEntity and toEntity should preserve supported fields', () {
    final entity = AuthEntity(
      authId: 'u1',
      firstName: 'Ent',
      lastName: 'Ity',
      email: 'ent@example.com',
      password: 'entityPass',
      profilePicture: 'image.png',
    );

    final model = AuthApiModel.fromEntity(entity);

    expect(model.id, null); // fromEntity does not map authId in your model
    expect(model.email, 'ent@example.com');
    expect(model.password, 'entityPass');
    expect(model.role, 'user'); // default value
    expect(model.profile, null); // fromEntity does not map profilePicture in your model

    final back = model.toEntity();

    expect(back.authId, null);
    expect(back.email, 'ent@example.com');
    expect(back.password, 'entityPass');
    expect(back.firstName, '');
    expect(back.lastName, '');
    expect(back.profilePicture, null);
  });
}