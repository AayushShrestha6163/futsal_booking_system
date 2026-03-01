class CourtEntity {
  final String id;
  final String name;
  final String? location;
  final num? pricePerHour;
  final String? image;

  const CourtEntity({
    required this.id,
    required this.name,
    this.location,
    this.pricePerHour,
    this.image,
  });
}