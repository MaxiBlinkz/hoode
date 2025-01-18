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

part 'bookings_record.g.dart';

enum BookingsRecordFieldsEnum {
  id,
  created,
  updated,
  collectionId,
  collectionName,
  property,
  agent,
  user,
  status
}

enum BookingsRecordStatusEnum {
  @_i1.JsonValue('pending')
  pending,
  @_i1.JsonValue('confirmed')
  confirmed,
  @_i1.JsonValue('completed')
  completed,
  @_i1.JsonValue('cancelled')
  cancelled
}

@_i1.JsonSerializable()
final class BookingsRecord extends _i2.BaseRecord {
  BookingsRecord({
    required super.id,
    required super.created,
    required super.updated,
    required super.collectionId,
    required super.collectionName,
    this.property,
    this.agent,
    this.user,
    this.status,
  });

  factory BookingsRecord.fromJson(Map<String, dynamic> json) =>
      _$BookingsRecordFromJson(json);

  factory BookingsRecord.fromRecordModel(_i3.RecordModel recordModel) {
    final extendedJsonMap = {
      ...recordModel.data,
      BookingsRecordFieldsEnum.id.name: recordModel.id,
      BookingsRecordFieldsEnum.created.name: recordModel.created,
      BookingsRecordFieldsEnum.updated.name: recordModel.updated,
      BookingsRecordFieldsEnum.collectionId.name: recordModel.collectionId,
      BookingsRecordFieldsEnum.collectionName.name: recordModel.collectionName,
    };
    return BookingsRecord.fromJson(extendedJsonMap);
  }

  final String? property;

  final String? agent;

  final String? user;

  final BookingsRecordStatusEnum? status;

  static const $collectionId = '5j0yl97dy133qjw';

  static const $collectionName = 'bookings';

  Map<String, dynamic> toJson() => _$BookingsRecordToJson(this);

  BookingsRecord copyWith({
    String? property,
    String? agent,
    String? user,
    BookingsRecordStatusEnum? status,
  }) {
    return BookingsRecord(
      id: id,
      created: created,
      updated: updated,
      collectionId: collectionId,
      collectionName: collectionName,
      property: property ?? this.property,
      agent: agent ?? this.agent,
      user: user ?? this.user,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> takeDiff(BookingsRecord other) {
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
        property,
        agent,
        user,
        status,
      ];

  static Map<String, dynamic> forCreateRequest({
    String? property,
    String? agent,
    String? user,
    BookingsRecordStatusEnum? status,
  }) {
    final jsonMap = BookingsRecord(
      id: '',
      created: _i5.EmptyDateTime(),
      updated: _i5.EmptyDateTime(),
      collectionId: $collectionId,
      collectionName: $collectionName,
      property: property,
      agent: agent,
      user: user,
      status: status,
    ).toJson();
    final Map<String, dynamic> result = {};
    if (property != null) {
      result.addAll({
        BookingsRecordFieldsEnum.property.name:
            jsonMap[BookingsRecordFieldsEnum.property.name]
      });
    }
    if (agent != null) {
      result.addAll({
        BookingsRecordFieldsEnum.agent.name:
            jsonMap[BookingsRecordFieldsEnum.agent.name]
      });
    }
    if (user != null) {
      result.addAll({
        BookingsRecordFieldsEnum.user.name:
            jsonMap[BookingsRecordFieldsEnum.user.name]
      });
    }
    if (status != null) {
      result.addAll({
        BookingsRecordFieldsEnum.status.name:
            jsonMap[BookingsRecordFieldsEnum.status.name]
      });
    }
    return result;
  }
}
