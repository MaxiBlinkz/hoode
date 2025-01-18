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

part 'conversations_record.g.dart';

enum ConversationsRecordFieldsEnum {
  id,
  created,
  updated,
  collectionId,
  collectionName,
  participants,
  title,
  last_message,
  is_group
}

@_i1.JsonSerializable()
final class ConversationsRecord extends _i2.BaseRecord {
  ConversationsRecord({
    required super.id,
    required super.created,
    required super.updated,
    required super.collectionId,
    required super.collectionName,
    required this.participants,
    required this.title,
    this.last_message,
    this.is_group,
  });

  factory ConversationsRecord.fromJson(Map<String, dynamic> json) =>
      _$ConversationsRecordFromJson(json);

  factory ConversationsRecord.fromRecordModel(_i3.RecordModel recordModel) {
    final extendedJsonMap = {
      ...recordModel.data,
      ConversationsRecordFieldsEnum.id.name: recordModel.id,
      ConversationsRecordFieldsEnum.created.name: recordModel.created,
      ConversationsRecordFieldsEnum.updated.name: recordModel.updated,
      ConversationsRecordFieldsEnum.collectionId.name: recordModel.collectionId,
      ConversationsRecordFieldsEnum.collectionName.name:
          recordModel.collectionName,
    };
    return ConversationsRecord.fromJson(extendedJsonMap);
  }

  final List<String> participants;

  final String title;

  static const titleMinValue = 1;

  final String? last_message;

  final bool? is_group;

  static const $collectionId = 'bhiii7ntpqn1crq';

  static const $collectionName = 'conversations';

  Map<String, dynamic> toJson() => _$ConversationsRecordToJson(this);

  ConversationsRecord copyWith({
    List<String>? participants,
    String? title,
    String? last_message,
    bool? is_group,
  }) {
    return ConversationsRecord(
      id: id,
      created: created,
      updated: updated,
      collectionId: collectionId,
      collectionName: collectionName,
      participants: participants ?? this.participants,
      title: title ?? this.title,
      last_message: last_message ?? this.last_message,
      is_group: is_group ?? this.is_group,
    );
  }

  Map<String, dynamic> takeDiff(ConversationsRecord other) {
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
        participants,
        title,
        last_message,
        is_group,
      ];

  static Map<String, dynamic> forCreateRequest({
    required List<String> participants,
    required String title,
    String? last_message,
    bool? is_group,
  }) {
    final jsonMap = ConversationsRecord(
      id: '',
      created: _i5.EmptyDateTime(),
      updated: _i5.EmptyDateTime(),
      collectionId: $collectionId,
      collectionName: $collectionName,
      participants: participants,
      title: title,
      last_message: last_message,
      is_group: is_group,
    ).toJson();
    final Map<String, dynamic> result = {};
    result.addAll({
      ConversationsRecordFieldsEnum.participants.name:
          jsonMap[ConversationsRecordFieldsEnum.participants.name]
    });
    result.addAll({
      ConversationsRecordFieldsEnum.title.name:
          jsonMap[ConversationsRecordFieldsEnum.title.name]
    });
    if (last_message != null) {
      result.addAll({
        ConversationsRecordFieldsEnum.last_message.name:
            jsonMap[ConversationsRecordFieldsEnum.last_message.name]
      });
    }
    if (is_group != null) {
      result.addAll({
        ConversationsRecordFieldsEnum.is_group.name:
            jsonMap[ConversationsRecordFieldsEnum.is_group.name]
      });
    }
    return result;
  }
}
