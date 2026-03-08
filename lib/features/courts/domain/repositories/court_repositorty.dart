import '../entities/court_entity.dart';

abstract class CourtRepository {
  Future<List<CourtEntity>> getAllCourts();
  Future<CourtEntity> getCourtById(String id);
}