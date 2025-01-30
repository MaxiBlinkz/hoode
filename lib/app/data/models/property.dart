import 'package:json_annotation/json_annotation.dart';
import 'package:pocketbase/pocketbase.dart';

part 'property.g.dart';

@JsonSerializable()
class Property {
  final String id;
  final String title;
  final double price;
  final String description;
  final String location;
  final String image;
  final int viewCount;
  final int favoriteCount;
  final double rating;
  final String category;
  final int bathrooms;
  final int bedrooms;
  final double latitude;
  final double longitude;

  Property(
      {required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.location,
    required this.image,
    required this.viewCount,
    required this.favoriteCount,
    required this.rating,
    required this.category,
    required this.bathrooms,
    required this.bedrooms,
    required this.latitude,
    required this.longitude,});

  factory Property.fromRecord(RecordModel record) =>
      Property.fromJson(record.toJson());

  factory Property.fromJson(Map<String, dynamic> json) =>
      _$PropertyFromJson(json);

  Map<String, dynamic> toJson() => _$PropertyToJson(this);
}
