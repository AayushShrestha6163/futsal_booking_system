import '../entities/court_entity.dart';
import '../repositories/court_repositorty.dart';

class GetCourtByIdUsecase {
  final CourtRepository repo;
  GetCourtByIdUsecase(this.repo);

  Future<CourtEntity> call(String id) => repo.getCourtById(id);
}