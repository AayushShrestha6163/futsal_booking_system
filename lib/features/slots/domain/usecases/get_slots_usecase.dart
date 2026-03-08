import '../entities/slot_entity.dart';
import '../repositories/slot_repository.dart';

class GetSlotsUsecase {
  final SlotRepository repo;
  GetSlotsUsecase(this.repo);

  Future<List<SlotEntity>> call(String courtId, String date) {
    return repo.getSlots(courtId, date);
  }
}