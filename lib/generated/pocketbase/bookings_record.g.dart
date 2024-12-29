// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookings_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookingsRecord _$BookingsRecordFromJson(Map<String, dynamic> json) =>
    BookingsRecord(
      id: json['id'] as String,
      created: pocketBaseDateTimeFromJson(json['created'] as String),
      updated: pocketBaseDateTimeFromJson(json['updated'] as String),
      collectionId: json['collectionId'] as String,
      collectionName: json['collectionName'] as String,
      property: json['property'] as String?,
      agent: json['agent'] as String?,
      user: json['user'] as String?,
      status: $enumDecodeNullable(
          _$BookingsRecordStatusEnumEnumMap, json['status']),
    );

Map<String, dynamic> _$BookingsRecordToJson(BookingsRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created': pocketBaseDateTimeToJson(instance.created),
      'updated': pocketBaseDateTimeToJson(instance.updated),
      'collectionId': instance.collectionId,
      'collectionName': instance.collectionName,
      'property': instance.property,
      'agent': instance.agent,
      'user': instance.user,
      'status': _$BookingsRecordStatusEnumEnumMap[instance.status],
    };

const _$BookingsRecordStatusEnumEnumMap = {
  BookingsRecordStatusEnum.pending: 'pending',
  BookingsRecordStatusEnum.confirmed: 'confirmed',
  BookingsRecordStatusEnum.completed: 'completed',
  BookingsRecordStatusEnum.cancelled: 'cancelled',
};
