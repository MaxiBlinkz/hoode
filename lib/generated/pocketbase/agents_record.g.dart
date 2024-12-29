// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agents_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AgentsRecord _$AgentsRecordFromJson(Map<String, dynamic> json) => AgentsRecord(
      id: json['id'] as String,
      created: pocketBaseDateTimeFromJson(json['created'] as String),
      updated: pocketBaseDateTimeFromJson(json['updated'] as String),
      collectionId: json['collectionId'] as String,
      collectionName: json['collectionName'] as String,
      user: json['user'] as String?,
      name: json['name'] as String?,
      title: json['title'] as String?,
      bio: json['bio'] as String?,
      specialization: $enumDecodeNullable(
          _$AgentsRecordSpecializationEnumEnumMap, json['specialization']),
      licence: json['licence'] as String?,
      contact: json['contact'],
      avatar: json['avatar'] as String?,
      ratings: (json['ratings'] as num?)?.toDouble(),
      total_bookings: (json['total_bookings'] as num?)?.toDouble(),
      total_listings: (json['total_listings'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$AgentsRecordToJson(AgentsRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created': pocketBaseDateTimeToJson(instance.created),
      'updated': pocketBaseDateTimeToJson(instance.updated),
      'collectionId': instance.collectionId,
      'collectionName': instance.collectionName,
      'user': instance.user,
      'name': instance.name,
      'title': instance.title,
      'bio': instance.bio,
      'specialization':
          _$AgentsRecordSpecializationEnumEnumMap[instance.specialization],
      'licence': instance.licence,
      'contact': instance.contact,
      'avatar': instance.avatar,
      'ratings': instance.ratings,
      'total_bookings': instance.total_bookings,
      'total_listings': instance.total_listings,
    };

const _$AgentsRecordSpecializationEnumEnumMap = {
  AgentsRecordSpecializationEnum.residential: 'residential',
  AgentsRecordSpecializationEnum.commercial: 'commercial',
  AgentsRecordSpecializationEnum.luxury: 'luxury',
};
