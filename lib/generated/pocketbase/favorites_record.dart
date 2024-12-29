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

part 'favorites_record.g.dart';

enum FavoritesRecordFieldsEnum {
  id,
  created,
  updated,
  collectionId,
  collectionName,
  user,
  property
}

@_i1.JsonSerializable()
final class FavoritesRecord extends _i2.BaseRecord {
  FavoritesRecord({
    required super.id,
    required super.created,
    required super.updated,
    required super.collectionId,
    required super.collectionName,
    this.user,
    this.property,
  });

  factory FavoritesRecord.fromJson(Map<String, dynamic> json) =>
      _$FavoritesRecordFromJson(json);

  factory FavoritesRecord.fromRecordModel(_i3.RecordModel recordModel) {
    final extendedJsonMap = {
      ...recordModel.data,
      FavoritesRecordFieldsEnum.id.name: recordModel.id,
      FavoritesRecordFieldsEnum.created.name: recordModel.created,
      FavoritesRecordFieldsEnum.updated.name: recordModel.updated,
      FavoritesRecordFieldsEnum.collectionId.name: recordModel.collectionId,
      FavoritesRecordFieldsEnum.collectionName.name: recordModel.collectionName,
    };
    return FavoritesRecord.fromJson(extendedJsonMap);
  }

  final String? user;

  final String? property;

  static const $collectionId = 'hj4g2px6sjiqalt';

  static const $collectionName = 'favorites';

  Map<String, dynamic> toJson() => _$FavoritesRecordToJson(this);

  FavoritesRecord copyWith({
    String? user,
    String? property,
  }) {
    return FavoritesRecord(
      id: id,
      created: created,
      updated: updated,
      collectionId: collectionId,
      collectionName: collectionName,
      user: user ?? this.user,
      property: property ?? this.property,
    );
  }

  Map<String, dynamic> takeDiff(FavoritesRecord other) {
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
        user,
        property,
      ];

  static Map<String, dynamic> forCreateRequest({
    String? user,
    String? property,
  }) {
    final jsonMap = FavoritesRecord(
      id: '',
      created: _i5.EmptyDateTime(),
      updated: _i5.EmptyDateTime(),
      collectionId: $collectionId,
      collectionName: $collectionName,
      user: user,
      property: property,
    ).toJson();
    final Map<String, dynamic> result = {};
    if (user != null) {
      result.addAll({
        FavoritesRecordFieldsEnum.user.name:
            jsonMap[FavoritesRecordFieldsEnum.user.name]
      });
    }
    if (property != null) {
      result.addAll({
        FavoritesRecordFieldsEnum.property.name:
            jsonMap[FavoritesRecordFieldsEnum.property.name]
      });
    }
    return result;
  }
}
