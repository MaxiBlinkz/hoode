import 'package:json_annotation/json_annotation.dart';
import 'package:pocketbase/pocketbase.dart';

part 'property.g.dart';

@JsonSerializable()
class Property {
  final String id, title, description, type, location, image;
  final double price;
  final List status;

  Property(
      {required this.id,
      required this.title,
      required this.description,
      required this.price,
      required this.location,
      required this.image,
      required this.status,
      required this.type});
      
  factory Property.fromRecord(RecordModel record) => Property.fromJson(record.toJson());

  factory Property.fromJson(Map<String, dynamic> json) =>
      _$PropertyFromJson(json);

  Map<String, dynamic> toJson() => _$PropertyToJson(this);
}
