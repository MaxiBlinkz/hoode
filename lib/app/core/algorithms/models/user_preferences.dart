import 'geo_point.dart';

class UserPreferences {
  final double targetPrice;
  final GeoPoint preferredLocation;
  final List<String> preferredAmenities;
  final String preferredType;

  UserPreferences({
    required this.targetPrice,
    required this.preferredLocation,
    required this.preferredAmenities,
    required this.preferredType,
  });
}