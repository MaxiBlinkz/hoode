// GENERATED CODE - DO NOT MODIFY BY HAND
// *****************************************************
// POCKETBASE_UTILS
// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint

// ignore_for_file: unused_import

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:equatable/equatable.dart' as _i1;
import 'package:json_annotation/json_annotation.dart' as _i2;
import 'package:json_annotation/json_annotation.dart';

import 'date_time_json_methods.dart';

abstract base class BaseRecord extends _i1.Equatable {
  BaseRecord({
    required this.id,
    required this.created,
    required this.updated,
    required this.collectionId,
    required this.collectionName,
  });

  final String id;

  @_i2.JsonKey(
    toJson: pocketBaseDateTimeToJson,
    fromJson: pocketBaseDateTimeFromJson,
  )
  final DateTime created;

  @_i2.JsonKey(
    toJson: pocketBaseDateTimeToJson,
    fromJson: pocketBaseDateTimeFromJson,
  )
  final DateTime updated;

  final String collectionId;

  final String collectionName;

  @override
  List<Object?> get props => [
        id,
        created,
        updated,
        collectionId,
        collectionName,
      ];
}
