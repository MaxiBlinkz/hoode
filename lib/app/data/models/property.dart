// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

part 'property.g.dart';

@JsonSerializable()
class Property {
  final String property_id;
  final String agent_id;
  final String title;
  final String description;
  final String price;
  final String location;
  final String latitude;
  final String longitude;
  final String property_type;
  final String status;
  final String created_at;
  final String updated_at;
  final String image_url;
  final bool featured;
  Property({
    required this.property_id,
    required this.agent_id,
    required this.title,
    required this.description,
    required this.price,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.property_type,
    required this.status,
    required this.created_at,
    required this.updated_at,
    required this.image_url,
    required this.featured,
  });

 factory Property.fromJson(Map<String, dynamic> json) => _$PropertyFromJson(json);

  Map<String,dynamic> toJson() => _$PropertyToJson(this);
}
