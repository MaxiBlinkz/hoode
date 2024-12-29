// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'messages_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessagesRecord _$MessagesRecordFromJson(Map<String, dynamic> json) =>
    MessagesRecord(
      id: json['id'] as String,
      created: pocketBaseDateTimeFromJson(json['created'] as String),
      updated: pocketBaseDateTimeFromJson(json['updated'] as String),
      collectionId: json['collectionId'] as String,
      collectionName: json['collectionName'] as String,
      content: json['content'] as String,
      sender_id: json['sender_id'] as String,
      reciever_id: json['reciever_id'] as String,
      conversation_id: json['conversation_id'] as String,
      file: (json['file'] as List<dynamic>?)?.map((e) => e as String).toList(),
      reply_to: json['reply_to'] as String?,
      status: $enumDecodeNullable(
          _$MessagesRecordStatusEnumEnumMap, json['status']),
      type: $enumDecodeNullable(_$MessagesRecordTypeEnumEnumMap, json['type']),
    );

Map<String, dynamic> _$MessagesRecordToJson(MessagesRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created': pocketBaseDateTimeToJson(instance.created),
      'updated': pocketBaseDateTimeToJson(instance.updated),
      'collectionId': instance.collectionId,
      'collectionName': instance.collectionName,
      'content': instance.content,
      'sender_id': instance.sender_id,
      'reciever_id': instance.reciever_id,
      'conversation_id': instance.conversation_id,
      'file': instance.file,
      'reply_to': instance.reply_to,
      'status': _$MessagesRecordStatusEnumEnumMap[instance.status],
      'type': _$MessagesRecordTypeEnumEnumMap[instance.type],
    };

const _$MessagesRecordStatusEnumEnumMap = {
  MessagesRecordStatusEnum.sent: 'sent',
  MessagesRecordStatusEnum.delivered: 'delivered',
  MessagesRecordStatusEnum.read: 'read',
  MessagesRecordStatusEnum.failed: 'failed',
};

const _$MessagesRecordTypeEnumEnumMap = {
  MessagesRecordTypeEnum.text: 'text',
  MessagesRecordTypeEnum.image: 'image',
  MessagesRecordTypeEnum.audio: 'audio',
  MessagesRecordTypeEnum.files: 'files',
  MessagesRecordTypeEnum.booking: 'booking',
};
