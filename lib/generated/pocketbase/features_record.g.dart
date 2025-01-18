// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'features_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeaturesRecord _$FeaturesRecordFromJson(Map<String, dynamic> json) =>
    FeaturesRecord(
      id: json['id'] as String,
      created: pocketBaseDateTimeFromJson(json['created'] as String),
      updated: pocketBaseDateTimeFromJson(json['updated'] as String),
      collectionId: json['collectionId'] as String,
      collectionName: json['collectionName'] as String,
      bedroom: (json['bedroom'] as num?)?.toDouble(),
      bath: (json['bath'] as num?)?.toDouble(),
      toilet: (json['toilet'] as num?)?.toDouble(),
      kitchen: (json['kitchen'] as num?)?.toDouble(),
      dining_room: (json['dining_room'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$FeaturesRecordToJson(FeaturesRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created': pocketBaseDateTimeToJson(instance.created),
      'updated': pocketBaseDateTimeToJson(instance.updated),
      'collectionId': instance.collectionId,
      'collectionName': instance.collectionName,
      'bedroom': instance.bedroom,
      'bath': instance.bath,
      'toilet': instance.toilet,
      'kitchen': instance.kitchen,
      'dining_room': instance.dining_room,
    };
