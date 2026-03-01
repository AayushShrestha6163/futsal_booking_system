import '../../domain/entities/court_entity.dart';

class CourtModel extends CourtEntity {
  const CourtModel({
    required super.id,
    required super.name,
    super.location,
    super.pricePerHour,
    super.image,
  });

  factory CourtModel.fromJson(Map<String, dynamic> json) {
  return CourtModel(
    id: (json['_id'] ?? json['id'] ?? '').toString(),
    name: (json['name'] ?? 'Unnamed Court').toString(),
    location: json['location']?.toString(),
    pricePerHour: json['pricePerHour'],
    image: json['image']?.toString(),
    
  );
}
}