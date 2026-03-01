import '../entities/slot_entity.dart';

abstract class SlotRepository {
  Future<List<SlotEntity>> getSlots(String courtId, String date);
}