// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final int user_id;
  final String name;
  final String email;
  final String password;
  final String user_type;
  final String profile_picture;
  final String contact_info;
  final DateTime created_at;
  final DateTime updated_at;
  User({
    required this.user_id,
    required this.name,
    required this.email,
    required this.password,
    required this.user_type,
    required this.profile_picture,
    required this.contact_info,
    required this.created_at,
    required this.updated_at,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String,dynamic> toJson() => _$UserToJson(this);
}
