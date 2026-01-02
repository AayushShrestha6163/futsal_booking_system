import 'package:dartz/dartz.dart';
import 'package:futal_booking_system/core/error/failure.dart';


abstract interface class UsecaseWithParms<SucessType, Params> {
  Future<Either<Failure, SucessType>> call(Params params);
}

abstract interface class UsecaseWithoutParms<SuccessType> {
  Future<Either<Failure, SuccessType>> call();
}