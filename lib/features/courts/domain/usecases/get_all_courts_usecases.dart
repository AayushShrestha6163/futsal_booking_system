import 'package:futal_booking_system/features/courts/domain/repositories/court_repositorty.dart';

import '../entities/court_entity.dart';


class GetAllCourtsUsecase {
  final CourtRepository repo;
  GetAllCourtsUsecase(this.repo);

  Future<List<CourtEntity>> call() => repo.getAllCourts();
}