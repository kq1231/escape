import 'package:flutter_test/flutter_test.dart';
import 'package:escape/services/location_service.dart';

void main() {
  group('LocationService Tests', () {
    late LocationService locationService;

    setUp(() {
      locationService = LocationService();
    });

    test('LocationService should be a singleton', () {
      final instance1 = LocationService();
      final instance2 = LocationService();

      expect(instance1, equals(instance2));
    });

    test('LocationInfo should serialize and deserialize correctly', () {
      final locationInfo = LocationInfo(
        city: 'Test City',
        country: 'Test Country',
        latitude: 12.345,
        longitude: 67.890,
        fullAddress: 'Test Street, Test City, Test Country',
      );

      final json = locationInfo.toJson();
      final restored = LocationInfo.fromJson(json);

      expect(restored.city, equals(locationInfo.city));
      expect(restored.country, equals(locationInfo.country));
      expect(restored.latitude, equals(locationInfo.latitude));
      expect(restored.longitude, equals(locationInfo.longitude));
      expect(restored.fullAddress, equals(locationInfo.fullAddress));
    });

    test('LocationInfo toString should return formatted string', () {
      final locationInfo = LocationInfo(
        city: 'Test City',
        country: 'Test Country',
        latitude: 12.345,
        longitude: 67.890,
        fullAddress: 'Test Street, Test City, Test Country',
      );

      final result = locationInfo.toString();
      expect(result, contains('Test City'));
      expect(result, contains('Test Country'));
      expect(result, contains('12.345'));
      expect(
        result,
        contains('67.89'),
      ); // Note: toString formats as 67.89, not 67.890
    });
  });
}
