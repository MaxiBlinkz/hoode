// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookmarks_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookmarksRecord _$BookmarksRecordFromJson(Map<String, dynamic> json) =>
    BookmarksRecord(
      id: json['id'] as String,
      created: pocketBaseDateTimeFromJson(json['created'] as String),
      updated: pocketBaseDateTimeFromJson(json['updated'] as String),
      collectionId: json['collectionId'] as String,
      collectionName: json['collectionName'] as String,
      user: json['user'] as String?,
      properties: (json['properties'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$BookmarksRecordToJson(BookmarksRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created': pocketBaseDateTimeToJson(instance.created),
      'updated': pocketBaseDateTimeToJson(instance.updated),
      'collectionId': instance.collectionId,
      'collectionName': instance.collectionName,
      'user': instance.user,
      'properties': instance.properties,
    };
