import 'package:futal_booking_system/core/constants/hive_table_constant.dart';
import 'package:futal_booking_system/features/auth/domain/entities/auth_entity.dart';
import 'package:hive/hive.dart';

import 'package:uuid/uuid.dart';

part 'auth_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.authTypeId)
class AuthHiveModel extends HiveObject {
  @HiveField(0)
  final String? authId;

  @HiveField(1)
  final String firstName;

  @HiveField(2)
  final String lastName;

  @HiveField(3)
  final String email;

  @HiveField(4)
  final String? password;

  @HiveField(5)
  final String? profilePicture;

  AuthHiveModel({
    String? authId,
    required this.firstName,
    required this.lastName,
    required this.email,
    
    this.password,
    
    this.profilePicture,
  }) : authId = authId ?? const Uuid().v4();

  // To Entity
  AuthEntity toEntity() {
    return AuthEntity(
      authId: authId,
      firstName: firstName,
      lastName: lastName,
      email: email,
      
      password: password,
      
      profilePicture: profilePicture,
    );
  }

  // From Entity
  factory AuthHiveModel.fromEntity(AuthEntity entity) {
    return AuthHiveModel(
      authId: entity.authId,
      firstName: entity.firstName,
      lastName: entity.lastName,
      email: entity.email,
      password: entity.password,
      profilePicture: entity.profilePicture,
    );
  }

  // To Entity List
  static List<AuthEntity> toEntityList(List<AuthHiveModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
