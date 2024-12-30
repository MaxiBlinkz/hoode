import 'package:flutter_test/flutter_test.dart';
import 'package:hoode/app/core/algorithms/models/user_preferences.dart';
import 'package:hoode/app/core/algorithms/models/geo_point.dart';

void main() {
  group('UserPreferences Tests', () {
    test('should create UserPreferences with correct values', () {
      final prefs = UserPreferences(
        targetPrice: 250000.0,
        preferredLocation: GeoPoint(latitude: 40.7128, longitude: -74.0060),
        preferredAmenities: ['parking', 'pool'],
        preferredType: 'apartment'
      );

      expect(prefs.targetPrice, 250000.0);
      expect(prefs.preferredLocation.latitude, 40.7128);
      expect(prefs.preferredAmenities, ['parking', 'pool']);
      expect(prefs.preferredType, 'apartment');
    });
  });
}
