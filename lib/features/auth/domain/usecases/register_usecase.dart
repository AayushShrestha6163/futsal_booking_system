import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futal_booking_system/core/error/failure.dart';
import 'package:futal_booking_system/core/usecases/app_usecases.dart';
import 'package:futal_booking_system/features/auth/data/repositories/auth_repository.dart';
import 'package:futal_booking_system/features/auth/domain/entities/auth_entity.dart';
import 'package:futal_booking_system/features/auth/domain/repositories/auth_repository.dart';


class RegisterParams extends Equatable {
  final String firstName;
  final String lastName;
  final String email;  
  final String password;
 

  const RegisterParams({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
   
  });

  @override
  List<Object?> get props => [
    firstName,
    lastName,
    email,
    password,
    
  ];
}

// Create Provider
final registerUsecaseProvider = Provider<RegisterUsecase>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return RegisterUsecase(authRepository: authRepository);
});

class RegisterUsecase implements UsecaseWithParms<bool, RegisterParams> {
  final IAuthRepository _authRepository;

  RegisterUsecase({required IAuthRepository authRepository})
    : _authRepository = authRepository;

  @override
  Future<Either<Failure, bool>> call(RegisterParams params) {
    final authEntity = AuthEntity(
      firstName: params.firstName,
      lastName: params.lastName,
      email: params.email,
      password: params.password,
      
    );

    return _authRepository.register(authEntity);
  }
}