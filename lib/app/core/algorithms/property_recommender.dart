import 'package:hoode/app/data/extensions/record_model_extension.dart';
import 'package:latlong2/latlong.dart';
import 'package:pocketbase/pocketbase.dart';

import 'models/geo_point.dart';
import 'models/market_trends.dart';
import 'models/seasonal_data.dart';
import 'models/user_interaction_history.dart';
import 'models/user_preferences.dart';

class PropertyRecommender {
  static const double locationWeight = 0.4;
  static const double priceWeight = 0.3;
  static const double interactionWeight = 0.15;
  static const double seasonalWeight = 0.15;
  static const double trendWeight = 0.15;

  // Distance calculator
  static final Distance distance = Distance();

  static List<RecordModel> getRecommendations(
    List<RecordModel> allProperties,
    UserPreferences userPrefs,
    UserInteractionHistory interactions,
    MarketTrends trends,
    SeasonalData seasonal,
  ) {
    final scoredProperties = allProperties.map((property) {
      final score = _calculateEnhancedScore(
        property, 
        userPrefs,
        interactions,
        trends,
        seasonal,
      );
      return MapEntry(property, score);
    }).toList();

    scoredProperties.sort((a, b) => b.value.compareTo(a.value));
    return scoredProperties.take(10).map((e) => e.key).toList();
  }

  static double _calculateEnhancedScore(
    RecordModel property,
    UserPreferences userPrefs,
    UserInteractionHistory interactions,
    MarketTrends trends,
    SeasonalData seasonal,
  ) {
    double score = 0.0;

    // Price and market trend analysis
    final priceScore = _calculatePriceScore(property, userPrefs, trends);
    score += priceScore * priceWeight;

    // Precise location scoring using coordinates
    final locationScore = _calculateDistanceScore(
      property.getGeoPoint(),
      userPrefs.preferredLocation,
    );
    score += locationScore * locationWeight;

    // User interaction history
    final interactionScore = _calculateInteractionScore(
      property,
      interactions,
    );
    score += interactionScore * interactionWeight;

    // Seasonal relevance
    final seasonalScore = _calculateSeasonalScore(
      property,
      seasonal,
    );
    score += seasonalScore * seasonalWeight;

    // Market trends impact
    final trendScore = _calculateTrendScore(
      property,
      trends,
    );
    score += trendScore * trendWeight;

    return score;
  }

  static double _calculatePriceScore(
    RecordModel property,
    UserPreferences prefs,
    MarketTrends trends,
  ) {
    final propertyPrice = property.getDouble('price');
    final prefPrice = prefs.targetPrice;
    
    // Basic price similarity
    double score = 1 - ((propertyPrice - prefPrice).abs() / prefPrice);
    
    // Adjust score based on price trends
    final priceGrowth = trends.getPriceGrowth(property.getString('location'));
    final futureValueScore = priceGrowth > 0 ? 0.2 : -0.1;
    
    return (score + futureValueScore).clamp(0.0, 1.0);
  }

  static double _calculateDistanceScore(
    GeoPoint propertyLocation,
    GeoPoint preferredLocation,
  ) {
    final meters = distance.distance(
      LatLng(propertyLocation.latitude, propertyLocation.longitude),
      LatLng(preferredLocation.latitude, preferredLocation.longitude),
    );
    
    // Convert to kilometers and normalize
    final km = meters / 1000;
    return (1 - (km / 20)).clamp(0.0, 1.0); // 20km as max relevant distance
  }

  static double _calculateInteractionScore(
    RecordModel property,
    UserInteractionHistory interactions,
  ) {
    double score = 0.0;
    
    // Views weight
    score += (interactions.getViewCount(property.id) / 10).clamp(0.0, 0.4);
    
    // Favorites bonus
    if (interactions.isFavorite(property.id)) score += 0.3;
    
    // Recent clicks
    score += (interactions.getRecentClicks(property.id) / 5).clamp(0.0, 0.3);
    
    return score;
  }

  static double _calculateSeasonalScore(
    RecordModel property,
    SeasonalData seasonal,
  ) {
    final currentSeason = seasonal.getCurrentSeason();
    final propertyType = property.getString('type');
    final features = property.getData('features') as List<dynamic>;
    
    double score = 0.0;
    
    // Summer preferences
    if (currentSeason == Season.summer) {
      if (features.contains('pool')) score += 0.3;
      if (features.contains('garden')) score += 0.2;
      if (features.contains('balcony')) score += 0.2;
    }
    
    // Winter preferences
    if (currentSeason == Season.winter) {
      if (features.contains('heating')) score += 0.3;
      if (features.contains('covered_parking')) score += 0.2;
    }
    
    return score.clamp(0.0, 1.0);
  }

  static double _calculateTrendScore(
    RecordModel property,
    MarketTrends trends,
  ) {
    final location = property.getString('location');
    
    double score = 0.0;
    
    // Market demand
    score += trends.getLocationDemand(location) * 0.4;
    
    // Price appreciation
    score += trends.getPriceAppreciation(location) * 0.3;
    
    // Development score
    score += trends.getDevelopmentScore(location) * 0.3;
    
    return score.clamp(0.0, 1.0);
  }
}