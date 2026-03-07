import 'package:flutter_test/flutter_test.dart';
import 'package:futal_booking_system/features/courts/data/models/court_model.dart';

void main() {
  group('CourtModel', () {
    test('should create CourtModel from valid JSON with _id', () {
      final json = {
        '_id': 'court123',
        'name': 'City Futsal',
        'location': 'Kathmandu',
        'pricePerHour': 2000,
        'image': 'court.png',
      };

      final model = CourtModel.fromJson(json);

      expect(model.id, 'court123');
      expect(model.name, 'City Futsal');
      expect(model.location, 'Kathmandu');
      expect(model.pricePerHour, 2000);
      expect(model.image, 'court.png');
    });

    test('should create CourtModel using id if _id is missing', () {
      final json = {
        'id': 'court456',
        'name': 'Arena Futsal',
      };

      final model = CourtModel.fromJson(json);

      expect(model.id, 'court456');
      expect(model.name, 'Arena Futsal');
      expect(model.location, null);
      expect(model.pricePerHour, null);
      expect(model.image, null);
    });

    test('should use default name when name is missing', () {
      final json = {
        '_id': 'court789',
      };

      final model = CourtModel.fromJson(json);

      expect(model.id, 'court789');
      expect(model.name, 'Unnamed Court');
    });
  });
}