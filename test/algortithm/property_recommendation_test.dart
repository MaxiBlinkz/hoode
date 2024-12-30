import 'package:flutter_test/flutter_test.dart';
import 'package:hoode/app/core/algorithms/models/geo_point.dart';
import 'package:hoode/app/core/algorithms/models/market_trends.dart';
import 'package:hoode/app/core/algorithms/models/seasonal_data.dart';
import 'package:hoode/app/core/algorithms/models/user_interaction_history.dart';
import 'package:hoode/app/core/algorithms/models/user_preferences.dart';
import 'package:hoode/app/core/algorithms/property_recommender.dart';
import 'package:pocketbase/pocketbase.dart';

import '../database/mock_property_database.dart';

void main() {
  group('PropertyRecommender Tests', () {
    late UserPreferences userPrefs;
    late UserInteractionHistory interactions;
    late MarketTrends trends;
    late SeasonalData seasonal;
    late List<RecordModel> mockProperties;

    setUp(() {
      userPrefs = UserPreferences(
        targetPrice: 250000.0,
        preferredLocation: GeoPoint(latitude: 4.7617, longitude: -6.1918), // Match first mock property
        preferredAmenities: ['parking', 'pool'],
        preferredType: 'apartment'
      );

      interactions = UserInteractionHistory(
        viewCounts: {},
        favorites: {},
        clicks: {}
      );

      trends = MarketTrends();
      seasonal = SeasonalData();
      mockProperties = MockPropertyDatabase.getMockProperties();
    });

    test('should prioritize properties closer to preferred location', () {
      final recommendations = PropertyRecommender.getRecommendations(
        mockProperties,
        userPrefs,
        interactions,
        trends,
        seasonal
      );

      // First recommendation should be the property closest to preferred location
      expect(recommendations.first.data['latitude'], 4.7617);
      expect(recommendations.first.data['longitude'], -6.1918);
    });
  });
}
