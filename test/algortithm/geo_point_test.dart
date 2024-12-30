import 'package:flutter_test/flutter_test.dart';
import 'package:hoode/app/core/algorithms/models/geo_point.dart';

void main() {
  group('GeoPoint Tests', () {
    test('should create GeoPoint with correct coordinates', () {
      final point = GeoPoint(latitude: 40.7128, longitude: -74.0060);
      expect(point.latitude, 40.7128);
      expect(point.longitude, -74.0060);
    });

    test('should correctly format toString output', () {
      final point = GeoPoint(latitude: 40.7128, longitude: -74.0060);
      expect(point.toString(), 'GeoPoint(40.7128, -74.006)');
    });
  });
}
