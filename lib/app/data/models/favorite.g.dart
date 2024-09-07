// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Favorite _$FavoriteFromJson(Map<String, dynamic> json) => Favorite(
      favorite_id: (json['favorite_id'] as num).toInt(),
      user_id: (json['user_id'] as num).toInt(),
      property_id: (json['property_id'] as num).toInt(),
      saved_at: DateTime.parse(json['saved_at'] as String),
    );

Map<String, dynamic> _$FavoriteToJson(Favorite instance) => <String, dynamic>{
      'favorite_id': instance.favorite_id,
      'user_id': instance.user_id,
      'property_id': instance.property_id,
      'saved_at': instance.saved_at.toIso8601String(),
    };
