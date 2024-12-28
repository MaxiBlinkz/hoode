class GeoPoint {
  final double latitude;
  final double longitude;

  const GeoPoint({
    required this.latitude,
    required this.longitude,
  });

  @override
  String toString() => 'GeoPoint($latitude, $longitude)';
}
