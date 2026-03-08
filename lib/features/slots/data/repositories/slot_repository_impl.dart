
import 'package:futal_booking_system/features/slots/data/datasources/remote/slot_remote_datasources.dart';
import 'package:futal_booking_system/features/slots/data/models/slot_model.dart';
import 'package:futal_booking_system/features/slots/domain/entities/slot_entity.dart';
import 'package:futal_booking_system/features/slots/domain/repositories/slot_repository.dart';

class SlotRepositoryImpl implements SlotRepository {
  final SlotRemoteDataSource remote;
  SlotRepositoryImpl(this.remote);

  @override
  Future<List<SlotEntity>> getSlots(String courtId, String date) async {
    final data = await remote.getSlots(courtId, date);

    final list = (data is Map && data["slots"] is List)
        ? List.from(data["slots"])
        : <dynamic>[];

    return list
        .map((e) => SlotModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }
}