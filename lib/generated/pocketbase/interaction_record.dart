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

part 'interaction_record.g.dart';

enum InteractionRecordFieldsEnum {
  id,
  created,
  updated,
  collectionId,
  collectionName,
  view_count,
  click_count,
  favourite_count,
  last_interaction_date
}

@_i1.JsonSerializable()
final class InteractionRecord extends _i2.BaseRecord {
  InteractionRecord({
    required super.id,
    required super.created,
    required super.updated,
    required super.collectionId,
    required super.collectionName,
    this.view_count,
    this.click_count,
    this.favourite_count,
    this.last_interaction_date,
  });

  factory InteractionRecord.fromJson(Map<String, dynamic> json) =>
      _$InteractionRecordFromJson(json);

  factory InteractionRecord.fromRecordModel(_i3.RecordModel recordModel) {
    final extendedJsonMap = {
      ...recordModel.data,
      InteractionRecordFieldsEnum.id.name: recordModel.id,
      InteractionRecordFieldsEnum.created.name: recordModel.created,
      InteractionRecordFieldsEnum.updated.name: recordModel.updated,
      InteractionRecordFieldsEnum.collectionId.name: recordModel.collectionId,
      InteractionRecordFieldsEnum.collectionName.name:
          recordModel.collectionName,
    };
    return InteractionRecord.fromJson(extendedJsonMap);
  }

  final double? view_count;

  final double? click_count;

  final double? favourite_count;

  @_i1.JsonKey(
    toJson: pocketBaseNullableDateTimeToJson,
    fromJson: pocketBaseNullableDateTimeFromJson,
  )
  final DateTime? last_interaction_date;

  static const $collectionId = 'hjq05um72s2c3bd';

  static const $collectionName = 'interaction';

  Map<String, dynamic> toJson() => _$InteractionRecordToJson(this);

  InteractionRecord copyWith({
    double? view_count,
    double? click_count,
    double? favourite_count,
    DateTime? last_interaction_date,
  }) {
    return InteractionRecord(
      id: id,
      created: created,
      updated: updated,
      collectionId: collectionId,
      collectionName: collectionName,
      view_count: view_count ?? this.view_count,
      click_count: click_count ?? this.click_count,
      favourite_count: favourite_count ?? this.favourite_count,
      last_interaction_date:
          last_interaction_date ?? this.last_interaction_date,
    );
  }

  Map<String, dynamic> takeDiff(InteractionRecord other) {
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
        view_count,
        click_count,
        favourite_count,
        last_interaction_date,
      ];

  static Map<String, dynamic> forCreateRequest({
    double? view_count,
    double? click_count,
    double? favourite_count,
    DateTime? last_interaction_date,
  }) {
    final jsonMap = InteractionRecord(
      id: '',
      created: _i5.EmptyDateTime(),
      updated: _i5.EmptyDateTime(),
      collectionId: $collectionId,
      collectionName: $collectionName,
      view_count: view_count,
      click_count: click_count,
      favourite_count: favourite_count,
      last_interaction_date: last_interaction_date,
    ).toJson();
    final Map<String, dynamic> result = {};
    if (view_count != null) {
      result.addAll({
        InteractionRecordFieldsEnum.view_count.name:
            jsonMap[InteractionRecordFieldsEnum.view_count.name]
      });
    }
    if (click_count != null) {
      result.addAll({
        InteractionRecordFieldsEnum.click_count.name:
            jsonMap[InteractionRecordFieldsEnum.click_count.name]
      });
    }
    if (favourite_count != null) {
      result.addAll({
        InteractionRecordFieldsEnum.favourite_count.name:
            jsonMap[InteractionRecordFieldsEnum.favourite_count.name]
      });
    }
    if (last_interaction_date != null) {
      result.addAll({
        InteractionRecordFieldsEnum.last_interaction_date.name:
            jsonMap[InteractionRecordFieldsEnum.last_interaction_date.name]
      });
    }
    return result;
  }
}
