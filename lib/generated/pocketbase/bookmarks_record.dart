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

part 'bookmarks_record.g.dart';

enum BookmarksRecordFieldsEnum {
  id,
  created,
  updated,
  collectionId,
  collectionName,
  user,
  properties
}

@_i1.JsonSerializable()
final class BookmarksRecord extends _i2.BaseRecord {
  BookmarksRecord({
    required super.id,
    required super.created,
    required super.updated,
    required super.collectionId,
    required super.collectionName,
    this.user,
    this.properties,
  });

  factory BookmarksRecord.fromJson(Map<String, dynamic> json) =>
      _$BookmarksRecordFromJson(json);

  factory BookmarksRecord.fromRecordModel(_i3.RecordModel recordModel) {
    final extendedJsonMap = {
      ...recordModel.data,
      BookmarksRecordFieldsEnum.id.name: recordModel.id,
      BookmarksRecordFieldsEnum.created.name: recordModel.created,
      BookmarksRecordFieldsEnum.updated.name: recordModel.updated,
      BookmarksRecordFieldsEnum.collectionId.name: recordModel.collectionId,
      BookmarksRecordFieldsEnum.collectionName.name: recordModel.collectionName,
    };
    return BookmarksRecord.fromJson(extendedJsonMap);
  }

  final String? user;

  final List<String>? properties;

  static const $collectionId = 'phef8ii4vk6zlmr';

  static const $collectionName = 'bookmarks';

  Map<String, dynamic> toJson() => _$BookmarksRecordToJson(this);

  BookmarksRecord copyWith({
    String? user,
    List<String>? properties,
  }) {
    return BookmarksRecord(
      id: id,
      created: created,
      updated: updated,
      collectionId: collectionId,
      collectionName: collectionName,
      user: user ?? this.user,
      properties: properties ?? this.properties,
    );
  }

  Map<String, dynamic> takeDiff(BookmarksRecord other) {
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
        properties,
      ];

  static Map<String, dynamic> forCreateRequest({
    String? user,
    List<String>? properties,
  }) {
    final jsonMap = BookmarksRecord(
      id: '',
      created: _i5.EmptyDateTime(),
      updated: _i5.EmptyDateTime(),
      collectionId: $collectionId,
      collectionName: $collectionName,
      user: user,
      properties: properties,
    ).toJson();
    final Map<String, dynamic> result = {};
    if (user != null) {
      result.addAll({
        BookmarksRecordFieldsEnum.user.name:
            jsonMap[BookmarksRecordFieldsEnum.user.name]
      });
    }
    if (properties != null) {
      result.addAll({
        BookmarksRecordFieldsEnum.properties.name:
            jsonMap[BookmarksRecordFieldsEnum.properties.name]
      });
    }
    return result;
  }
}
