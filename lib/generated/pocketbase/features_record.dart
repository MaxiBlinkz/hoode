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

part 'features_record.g.dart';

enum FeaturesRecordFieldsEnum {
  id,
  created,
  updated,
  collectionId,
  collectionName,
  bedroom,
  bath,
  toilet,
  kitchen,
  dining_room
}

@_i1.JsonSerializable()
final class FeaturesRecord extends _i2.BaseRecord {
  FeaturesRecord({
    required super.id,
    required super.created,
    required super.updated,
    required super.collectionId,
    required super.collectionName,
    this.bedroom,
    this.bath,
    this.toilet,
    this.kitchen,
    this.dining_room,
  });

  factory FeaturesRecord.fromJson(Map<String, dynamic> json) =>
      _$FeaturesRecordFromJson(json);

  factory FeaturesRecord.fromRecordModel(_i3.RecordModel recordModel) {
    final extendedJsonMap = {
      ...recordModel.data,
      FeaturesRecordFieldsEnum.id.name: recordModel.id,
      FeaturesRecordFieldsEnum.created.name: recordModel.created,
      FeaturesRecordFieldsEnum.updated.name: recordModel.updated,
      FeaturesRecordFieldsEnum.collectionId.name: recordModel.collectionId,
      FeaturesRecordFieldsEnum.collectionName.name: recordModel.collectionName,
    };
    return FeaturesRecord.fromJson(extendedJsonMap);
  }

  final double? bedroom;

  final double? bath;

  final double? toilet;

  final double? kitchen;

  final double? dining_room;

  static const $collectionId = '9k3rmn63fvihlus';

  static const $collectionName = 'features';

  Map<String, dynamic> toJson() => _$FeaturesRecordToJson(this);

  FeaturesRecord copyWith({
    double? bedroom,
    double? bath,
    double? toilet,
    double? kitchen,
    double? dining_room,
  }) {
    return FeaturesRecord(
      id: id,
      created: created,
      updated: updated,
      collectionId: collectionId,
      collectionName: collectionName,
      bedroom: bedroom ?? this.bedroom,
      bath: bath ?? this.bath,
      toilet: toilet ?? this.toilet,
      kitchen: kitchen ?? this.kitchen,
      dining_room: dining_room ?? this.dining_room,
    );
  }

  Map<String, dynamic> takeDiff(FeaturesRecord other) {
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
        bedroom,
        bath,
        toilet,
        kitchen,
        dining_room,
      ];

  static Map<String, dynamic> forCreateRequest({
    double? bedroom,
    double? bath,
    double? toilet,
    double? kitchen,
    double? dining_room,
  }) {
    final jsonMap = FeaturesRecord(
      id: '',
      created: _i5.EmptyDateTime(),
      updated: _i5.EmptyDateTime(),
      collectionId: $collectionId,
      collectionName: $collectionName,
      bedroom: bedroom,
      bath: bath,
      toilet: toilet,
      kitchen: kitchen,
      dining_room: dining_room,
    ).toJson();
    final Map<String, dynamic> result = {};
    if (bedroom != null) {
      result.addAll({
        FeaturesRecordFieldsEnum.bedroom.name:
            jsonMap[FeaturesRecordFieldsEnum.bedroom.name]
      });
    }
    if (bath != null) {
      result.addAll({
        FeaturesRecordFieldsEnum.bath.name:
            jsonMap[FeaturesRecordFieldsEnum.bath.name]
      });
    }
    if (toilet != null) {
      result.addAll({
        FeaturesRecordFieldsEnum.toilet.name:
            jsonMap[FeaturesRecordFieldsEnum.toilet.name]
      });
    }
    if (kitchen != null) {
      result.addAll({
        FeaturesRecordFieldsEnum.kitchen.name:
            jsonMap[FeaturesRecordFieldsEnum.kitchen.name]
      });
    }
    if (dining_room != null) {
      result.addAll({
        FeaturesRecordFieldsEnum.dining_room.name:
            jsonMap[FeaturesRecordFieldsEnum.dining_room.name]
      });
    }
    return result;
  }
}
