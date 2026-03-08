class SlotEntity {
  final String time;       // "06:00-07:00"
  final bool available;

  const SlotEntity({
    required this.time,
    required this.available,
  });

  String get startTime => time.split('-').first;
  String get endTime => time.split('-').last;
}