// GENERATED CODE - DO NOT MODIFY BY HAND
// *****************************************************
// POCKETBASE_UTILS
// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint

// ignore_for_file: unused_import

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:collection/collection.dart' as _i4;
import 'package:json_annotation/json_annotation.dart' as _i1;
import 'package:json_annotation/json_annotation.dart';
import 'package:pocketbase/pocketbase.dart' as _i3;

import 'base_record.dart' as _i2;
import 'date_time_json_methods.dart';
import 'empty_values.dart' as _i5;

part 'market_record.g.dart';

enum MarketRecordFieldsEnum {
  id,
  created,
  updated,
  collectionId,
  collectionName,
  market_demand,
  price_trend,
  seasonal_rating
}

@_i1.JsonSerializable()
final class MarketRecord extends _i2.BaseRecord {
  MarketRecord({
    required super.id,
    required super.created,
    required super.updated,
    required super.collectionId,
    required super.collectionName,
    this.market_demand,
    this.price_trend,
    this.seasonal_rating,
  });

  factory MarketRecord.fromJson(Map<String, dynamic> json) =>
      _$MarketRecordFromJson(json);

  factory MarketRecord.fromRecordModel(_i3.RecordModel recordModel) {
    final extendedJsonMap = {
      ...recordModel.data,
      MarketRecordFieldsEnum.id.name: recordModel.id,
      MarketRecordFieldsEnum.created.name: recordModel.created,
      MarketRecordFieldsEnum.updated.name: recordModel.updated,
      MarketRecordFieldsEnum.collectionId.name: recordModel.collectionId,
      MarketRecordFieldsEnum.collectionName.name: recordModel.collectionName,
    };
    return MarketRecord.fromJson(extendedJsonMap);
  }

  final double? market_demand;

  final double? price_trend;

  final double? seasonal_rating;

  static const $collectionId = 'l8oeu8dkchfujgs';

  static const $collectionName = 'market';

  Map<String, dynamic> toJson() => _$MarketRecordToJson(this);

  MarketRecord copyWith({
    double? market_demand,
    double? price_trend,
    double? seasonal_rating,
  }) {
    return MarketRecord(
      id: id,
      created: created,
      updated: updated,
      collectionId: collectionId,
      collectionName: collectionName,
      market_demand: market_demand ?? this.market_demand,
      price_trend: price_trend ?? this.price_trend,
      seasonal_rating: seasonal_rating ?? this.seasonal_rating,
    );
  }

  Map<String, dynamic> takeDiff(MarketRecord other) {
    final thisInJsonMap = toJson();
    final otherInJsonMap = other.toJson();
    final Map<String, dynamic> result = {};
    final _i4.DeepCollectionEquality deepCollectionEquality =
        _i4.DeepCollectionEquality();
    for (final mapEntry in thisInJsonMap.entries) {
      final thisValue = mapEntry.value;
      final otherValue = otherInJsonMap[mapEntry.key];
      if (!deepCollectionEquality.equals(
        thisValue,
        otherValue,
      )) {
        result.addAll({mapEntry.key: otherValue});
      }
    }
    return result;
  }

  @override
  List<Object?> get props => [
        ...super.props,
        market_demand,
        price_trend,
        seasonal_rating,
      ];

  static Map<String, dynamic> forCreateRequest({
    double? market_demand,
    double? price_trend,
    double? seasonal_rating,
  }) {
    final jsonMap = MarketRecord(
      id: '',
      created: _i5.EmptyDateTime(),
      updated: _i5.EmptyDateTime(),
      collectionId: $collectionId,
      collectionName: $collectionName,
      market_demand: market_demand,
      price_trend: price_trend,
      seasonal_rating: seasonal_rating,
    ).toJson();
    final Map<String, dynamic> result = {};
    if (market_demand != null) {
      result.addAll({
        MarketRecordFieldsEnum.market_demand.name:
            jsonMap[MarketRecordFieldsEnum.market_demand.name]
      });
    }
    if (price_trend != null) {
      result.addAll({
        MarketRecordFieldsEnum.price_trend.name:
            jsonMap[MarketRecordFieldsEnum.price_trend.name]
      });
    }
    if (seasonal_rating != null) {
      result.addAll({
        MarketRecordFieldsEnum.seasonal_rating.name:
            jsonMap[MarketRecordFieldsEnum.seasonal_rating.name]
      });
    }
    return result;
  }
}
