import '../../core/algorithms/models/geo_point.dart';
import 'package:pocketbase/pocketbase.dart';

extension RecordModelExtension on RecordModel {
  GeoPoint getGeoPoint() {
    // final Map<String, dynamic> location = data['location'] as Map<String, dynamic>;
    return GeoPoint(
      latitude: data['latitude'] as double,
      longitude: data['longitude'] as double,
    );
  }

  double getDouble(String field) {
    return data[field] as double;
  }

  String getString(String field) {
    return data[field] as String;
  }

  dynamic getData(String field) {
    return data[field];
  }
}
