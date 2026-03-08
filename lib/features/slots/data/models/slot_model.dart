import '../../domain/entities/slot_entity.dart';

class SlotModel extends SlotEntity {
  const SlotModel({
    required super.time,
    required super.available,
  });

  factory SlotModel.fromJson(Map<String, dynamic> json) {
    return SlotModel(
      time: (json['time'] ?? '').toString(),
      available: json['available'] == true,
    );
  }
}