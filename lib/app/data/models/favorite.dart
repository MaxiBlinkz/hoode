// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

part 'favorite.g.dart';

@JsonSerializable()
class Favorite {
  final int favorite_id;
  final int user_id;
  final int property_id;
  final DateTime saved_at;
  Favorite({
    required this.favorite_id,
    required this.user_id,
    required this.property_id,
    required this.saved_at,
  });

  factory Favorite.fromJson(Map<String, dynamic> json) => _$FavoriteFromJson(json);

  Map<String,dynamic> toJson() => _$FavoriteToJson(this);
}
