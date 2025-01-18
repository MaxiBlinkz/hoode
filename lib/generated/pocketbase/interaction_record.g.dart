// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'interaction_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InteractionRecord _$InteractionRecordFromJson(Map<String, dynamic> json) =>
    InteractionRecord(
      id: json['id'] as String,
      created: pocketBaseDateTimeFromJson(json['created'] as String),
      updated: pocketBaseDateTimeFromJson(json['updated'] as String),
      collectionId: json['collectionId'] as String,
      collectionName: json['collectionName'] as String,
      view_count: (json['view_count'] as num?)?.toDouble(),
      click_count: (json['click_count'] as num?)?.toDouble(),
      favourite_count: (json['favourite_count'] as num?)?.toDouble(),
      last_interaction_date: pocketBaseNullableDateTimeFromJson(
          json['last_interaction_date'] as String),
    );

Map<String, dynamic> _$InteractionRecordToJson(InteractionRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created': pocketBaseDateTimeToJson(instance.created),
      'updated': pocketBaseDateTimeToJson(instance.updated),
      'collectionId': instance.collectionId,
      'collectionName': instance.collectionName,
      'view_count': instance.view_count,
      'click_count': instance.click_count,
      'favourite_count': instance.favourite_count,
      'last_interaction_date':
          pocketBaseNullableDateTimeToJson(instance.last_interaction_date),
    };
