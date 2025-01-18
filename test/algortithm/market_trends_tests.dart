import 'package:flutter_test/flutter_test.dart';
import 'package:hoode/app/core/algorithms/models/market_trends.dart';

void main() {
  group('MarketTrends Tests', () {
    late MarketTrends trends;

    setUp(() {
      trends = MarketTrends();
    });

    test('should return default location demand', () {
      expect(trends.getLocationDemand('New York'), 0.5);
    });

    test('should return default price appreciation', () {
      expect(trends.getPriceAppreciation('New York'), 0.5);
    });

    test('should return default development score', () {
      expect(trends.getDevelopmentScore('New York'), 0.5);
    });

    test('should return default price growth', () {
      expect(trends.getPriceGrowth('New York'), 0.05);
    });
  });
}
