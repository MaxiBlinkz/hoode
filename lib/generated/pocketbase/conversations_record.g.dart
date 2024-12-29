// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversations_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConversationsRecord _$ConversationsRecordFromJson(Map<String, dynamic> json) =>
    ConversationsRecord(
      id: json['id'] as String,
      created: pocketBaseDateTimeFromJson(json['created'] as String),
      updated: pocketBaseDateTimeFromJson(json['updated'] as String),
      collectionId: json['collectionId'] as String,
      collectionName: json['collectionName'] as String,
      participants: (json['participants'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      title: json['title'] as String,
      last_message: json['last_message'] as String?,
      is_group: json['is_group'] as bool?,
    );

Map<String, dynamic> _$ConversationsRecordToJson(
        ConversationsRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created': pocketBaseDateTimeToJson(instance.created),
      'updated': pocketBaseDateTimeToJson(instance.updated),
      'collectionId': instance.collectionId,
      'collectionName': instance.collectionName,
      'participants': instance.participants,
      'title': instance.title,
      'last_message': instance.last_message,
      'is_group': instance.is_group,
    };
