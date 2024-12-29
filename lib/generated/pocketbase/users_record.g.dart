// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'users_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UsersRecord _$UsersRecordFromJson(Map<String, dynamic> json) => UsersRecord(
      id: json['id'] as String,
      created: pocketBaseDateTimeFromJson(json['created'] as String),
      updated: pocketBaseDateTimeFromJson(json['updated'] as String),
      collectionId: json['collectionId'] as String,
      collectionName: json['collectionName'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      emailVisibility: json['emailVisibility'] as bool,
      verified: json['verified'] as bool,
      first_name: json['first_name'] as String?,
      avatar: json['avatar'] as String?,
      last_name: json['last_name'] as String?,
      country: json['country'] as String?,
      contact_info: (json['contact_info'] as num?)?.toDouble(),
      location: json['location'] as String?,
      state: json['state'] as String?,
      city: json['city'] as String?,
      lattitude: (json['lattitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      is_agent: json['is_agent'] as bool?,
      agent_status: $enumDecodeNullable(
          _$UsersRecordAgent_statusEnumEnumMap, json['agent_status']),
    );

Map<String, dynamic> _$UsersRecordToJson(UsersRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created': pocketBaseDateTimeToJson(instance.created),
      'updated': pocketBaseDateTimeToJson(instance.updated),
      'collectionId': instance.collectionId,
      'collectionName': instance.collectionName,
      'username': instance.username,
      'email': instance.email,
      'emailVisibility': instance.emailVisibility,
      'verified': instance.verified,
      'first_name': instance.first_name,
      'avatar': instance.avatar,
      'last_name': instance.last_name,
      'country': instance.country,
      'contact_info': instance.contact_info,
      'location': instance.location,
      'state': instance.state,
      'city': instance.city,
      'lattitude': instance.lattitude,
      'longitude': instance.longitude,
      'is_agent': instance.is_agent,
      'agent_status':
          _$UsersRecordAgent_statusEnumEnumMap[instance.agent_status],
    };

const _$UsersRecordAgent_statusEnumEnumMap = {
  UsersRecordAgent_statusEnum.active: 'active',
  UsersRecordAgent_statusEnum.pending: 'pending',
  UsersRecordAgent_statusEnum.inactive: 'inactive',
};
