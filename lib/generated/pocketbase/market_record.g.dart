// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'market_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MarketRecord _$MarketRecordFromJson(Map<String, dynamic> json) => MarketRecord(
      id: json['id'] as String,
      created: pocketBaseDateTimeFromJson(json['created'] as String),
      updated: pocketBaseDateTimeFromJson(json['updated'] as String),
      collectionId: json['collectionId'] as String,
      collectionName: json['collectionName'] as String,
      market_demand: (json['market_demand'] as num?)?.toDouble(),
      price_trend: (json['price_trend'] as num?)?.toDouble(),
      seasonal_rating: (json['seasonal_rating'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$MarketRecordToJson(MarketRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created': pocketBaseDateTimeToJson(instance.created),
      'updated': pocketBaseDateTimeToJson(instance.updated),
      'collectionId': instance.collectionId,
      'collectionName': instance.collectionName,
      'market_demand': instance.market_demand,
      'price_trend': instance.price_trend,
      'seasonal_rating': instance.seasonal_rating,
    };
