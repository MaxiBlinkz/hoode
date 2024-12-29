// GENERATED CODE - DO NOT MODIFY BY HAND
// *****************************************************
// POCKETBASE_UTILS
// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint

// ignore_for_file: unused_import

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:json_annotation/json_annotation.dart';

import 'base_record.dart' as _i1;
import 'date_time_json_methods.dart';

abstract base class AuthRecord extends _i1.BaseRecord {
  AuthRecord({
    required super.id,
    required super.created,
    required super.updated,
    required super.collectionId,
    required super.collectionName,
    required this.username,
    required this.email,
    required this.emailVisibility,
    required this.verified,
  });

  final String username;

  final String email;

  final bool emailVisibility;

  final bool verified;

  @override
  List<Object?> get props => [
        ...super.props,
        username,
        email,
        emailVisibility,
        verified,
      ];
}
