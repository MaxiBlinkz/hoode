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

part 'messages_record.g.dart';

enum MessagesRecordFieldsEnum {
  id,
  created,
  updated,
  collectionId,
  collectionName,
  content,
  sender_id,
  reciever_id,
  conversation_id,
  file,
  reply_to,
  status,
  type
}

enum MessagesRecordStatusEnum {
  @_i1.JsonValue('sent')
  sent,
  @_i1.JsonValue('delivered')
  delivered,
  @_i1.JsonValue('read')
  read,
  @_i1.JsonValue('failed')
  failed
}

enum MessagesRecordTypeEnum {
  @_i1.JsonValue('text')
  text,
  @_i1.JsonValue('image')
  image,
  @_i1.JsonValue('audio')
  audio,
  @_i1.JsonValue('files')
  files,
  @_i1.JsonValue('booking')
  booking
}

@_i1.JsonSerializable()
final class MessagesRecord extends _i2.BaseRecord {
  MessagesRecord({
    required super.id,
    required super.created,
    required super.updated,
    required super.collectionId,
    required super.collectionName,
    required this.content,
    required this.sender_id,
    required this.reciever_id,
    required this.conversation_id,
    this.file,
    this.reply_to,
    this.status,
    this.type,
  });

  factory MessagesRecord.fromJson(Map<String, dynamic> json) =>
      _$MessagesRecordFromJson(json);

  factory MessagesRecord.fromRecordModel(_i3.RecordModel recordModel) {
    final extendedJsonMap = {
      ...recordModel.data,
      MessagesRecordFieldsEnum.id.name: recordModel.id,
      MessagesRecordFieldsEnum.created.name: recordModel.created,
      MessagesRecordFieldsEnum.updated.name: recordModel.updated,
      MessagesRecordFieldsEnum.collectionId.name: recordModel.collectionId,
      MessagesRecordFieldsEnum.collectionName.name: recordModel.collectionName,
    };
    return MessagesRecord.fromJson(extendedJsonMap);
  }

  final String content;

  static const contentMinValue = 1;

  final String sender_id;

  final String reciever_id;

  final String conversation_id;

  final List<String>? file;

  final String? reply_to;

  final MessagesRecordStatusEnum? status;

  final MessagesRecordTypeEnum? type;

  static const $collectionId = 'rsi669atr32km3q';

  static const $collectionName = 'messages';

  Map<String, dynamic> toJson() => _$MessagesRecordToJson(this);

  MessagesRecord copyWith({
    String? content,
    String? sender_id,
    String? reciever_id,
    String? conversation_id,
    List<String>? file,
    String? reply_to,
    MessagesRecordStatusEnum? status,
    MessagesRecordTypeEnum? type,
  }) {
    return MessagesRecord(
      id: id,
      created: created,
      updated: updated,
      collectionId: collectionId,
      collectionName: collectionName,
      content: content ?? this.content,
      sender_id: sender_id ?? this.sender_id,
      reciever_id: reciever_id ?? this.reciever_id,
      conversation_id: conversation_id ?? this.conversation_id,
      file: file ?? this.file,
      reply_to: reply_to ?? this.reply_to,
      status: status ?? this.status,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> takeDiff(MessagesRecord other) {
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
        content,
        sender_id,
        reciever_id,
        conversation_id,
        file,
        reply_to,
        status,
        type,
      ];

  static Map<String, dynamic> forCreateRequest({
    required String content,
    required String sender_id,
    required String reciever_id,
    required String conversation_id,
    List<String>? file,
    String? reply_to,
    MessagesRecordStatusEnum? status,
    MessagesRecordTypeEnum? type,
  }) {
    final jsonMap = MessagesRecord(
      id: '',
      created: _i5.EmptyDateTime(),
      updated: _i5.EmptyDateTime(),
      collectionId: $collectionId,
      collectionName: $collectionName,
      content: content,
      sender_id: sender_id,
      reciever_id: reciever_id,
      conversation_id: conversation_id,
      file: file,
      reply_to: reply_to,
      status: status,
      type: type,
    ).toJson();
    final Map<String, dynamic> result = {};
    result.addAll({
      MessagesRecordFieldsEnum.content.name:
          jsonMap[MessagesRecordFieldsEnum.content.name]
    });
    result.addAll({
      MessagesRecordFieldsEnum.sender_id.name:
          jsonMap[MessagesRecordFieldsEnum.sender_id.name]
    });
    result.addAll({
      MessagesRecordFieldsEnum.reciever_id.name:
          jsonMap[MessagesRecordFieldsEnum.reciever_id.name]
    });
    result.addAll({
      MessagesRecordFieldsEnum.conversation_id.name:
          jsonMap[MessagesRecordFieldsEnum.conversation_id.name]
    });
    if (file != null) {
      result.addAll({
        MessagesRecordFieldsEnum.file.name:
            jsonMap[MessagesRecordFieldsEnum.file.name]
      });
    }
    if (reply_to != null) {
      result.addAll({
        MessagesRecordFieldsEnum.reply_to.name:
            jsonMap[MessagesRecordFieldsEnum.reply_to.name]
      });
    }
    if (status != null) {
      result.addAll({
        MessagesRecordFieldsEnum.status.name:
            jsonMap[MessagesRecordFieldsEnum.status.name]
      });
    }
    if (type != null) {
      result.addAll({
        MessagesRecordFieldsEnum.type.name:
            jsonMap[MessagesRecordFieldsEnum.type.name]
      });
    }
    return result;
  }
}
