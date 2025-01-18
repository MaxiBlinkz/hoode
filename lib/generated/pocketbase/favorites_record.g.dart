// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorites_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FavoritesRecord _$FavoritesRecordFromJson(Map<String, dynamic> json) =>
    FavoritesRecord(
      id: json['id'] as String,
      created: pocketBaseDateTimeFromJson(json['created'] as String),
      updated: pocketBaseDateTimeFromJson(json['updated'] as String),
      collectionId: json['collectionId'] as String,
      collectionName: json['collectionName'] as String,
      user: json['user'] as String?,
      property: json['property'] as String?,
    );

Map<String, dynamic> _$FavoritesRecordToJson(FavoritesRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created': pocketBaseDateTimeToJson(instance.created),
      'updated': pocketBaseDateTimeToJson(instance.updated),
      'collectionId': instance.collectionId,
      'collectionName': instance.collectionName,
      'user': instance.user,
      'property': instance.property,
    };
