// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reviews_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReviewsRecord _$ReviewsRecordFromJson(Map<String, dynamic> json) =>
    ReviewsRecord(
      id: json['id'] as String,
      created: pocketBaseDateTimeFromJson(json['created'] as String),
      updated: pocketBaseDateTimeFromJson(json['updated'] as String),
      collectionId: json['collectionId'] as String,
      collectionName: json['collectionName'] as String,
      user: json['user'] as String?,
      property: json['property'] as String?,
      rating: (json['rating'] as num?)?.toDouble(),
      content: json['content'] as String?,
    );

Map<String, dynamic> _$ReviewsRecordToJson(ReviewsRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created': pocketBaseDateTimeToJson(instance.created),
      'updated': pocketBaseDateTimeToJson(instance.updated),
      'collectionId': instance.collectionId,
      'collectionName': instance.collectionName,
      'user': instance.user,
      'property': instance.property,
      'rating': instance.rating,
      'content': instance.content,
    };
