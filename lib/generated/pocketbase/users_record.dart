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

import 'auth_record.dart' as _i2;
import 'date_time_json_methods.dart';
import 'empty_values.dart' as _i5;

part 'users_record.g.dart';

enum UsersRecordFieldsEnum {
  id,
  created,
  updated,
  collectionId,
  collectionName,
  username,
  email,
  emailVisibility,
  verified,

  /// THIS FIELD IS ONLY FOR CREATING AN AUTH TYPE RECORD
  password,

  /// THIS FIELD IS ONLY FOR CREATING AN AUTH TYPE RECORD
  passwordConfirm,
  first_name,
  avatar,
  last_name,
  country,
  contact_info,
  location,
  state,
  city,
  lattitude,
  longitude,
  is_agent,
  agent_status
}

enum UsersRecordAgent_statusEnum {
  @_i1.JsonValue('active')
  active,
  @_i1.JsonValue('pending')
  pending,
  @_i1.JsonValue('inactive')
  inactive
}

@_i1.JsonSerializable()
final class UsersRecord extends _i2.AuthRecord {
  UsersRecord({
    required super.id,
    required super.created,
    required super.updated,
    required super.collectionId,
    required super.collectionName,
    required super.username,
    required super.email,
    required super.emailVisibility,
    required super.verified,
    this.first_name,
    this.avatar,
    this.last_name,
    this.country,
    this.contact_info,
    this.location,
    this.state,
    this.city,
    this.lattitude,
    this.longitude,
    this.is_agent,
    this.agent_status,
  });

  factory UsersRecord.fromJson(Map<String, dynamic> json) =>
      _$UsersRecordFromJson(json);

  factory UsersRecord.fromRecordModel(_i3.RecordModel recordModel) {
    final extendedJsonMap = {
      ...recordModel.data,
      UsersRecordFieldsEnum.id.name: recordModel.id,
      UsersRecordFieldsEnum.created.name: recordModel.created,
      UsersRecordFieldsEnum.updated.name: recordModel.updated,
      UsersRecordFieldsEnum.collectionId.name: recordModel.collectionId,
      UsersRecordFieldsEnum.collectionName.name: recordModel.collectionName,
    };
    return UsersRecord.fromJson(extendedJsonMap);
  }

  final String? first_name;

  final String? avatar;

  final String? last_name;

  final String? country;

  final double? contact_info;

  final String? location;

  final String? state;

  final String? city;

  final double? lattitude;

  final double? longitude;

  final bool? is_agent;

  final UsersRecordAgent_statusEnum? agent_status;

  static const $collectionId = '_pb_users_auth_';

  static const $collectionName = 'users';

  Map<String, dynamic> toJson() => _$UsersRecordToJson(this);

  UsersRecord copyWith({
    String? username,
    String? email,
    bool? emailVisibility,
    bool? verified,
    String? first_name,
    String? avatar,
    String? last_name,
    String? country,
    double? contact_info,
    String? location,
    String? state,
    String? city,
    double? lattitude,
    double? longitude,
    bool? is_agent,
    UsersRecordAgent_statusEnum? agent_status,
  }) {
    return UsersRecord(
      id: id,
      created: created,
      updated: updated,
      collectionId: collectionId,
      collectionName: collectionName,
      username: username ?? this.username,
      email: email ?? this.email,
      emailVisibility: emailVisibility ?? this.emailVisibility,
      verified: verified ?? this.verified,
      first_name: first_name ?? this.first_name,
      avatar: avatar ?? this.avatar,
      last_name: last_name ?? this.last_name,
      country: country ?? this.country,
      contact_info: contact_info ?? this.contact_info,
      location: location ?? this.location,
      state: state ?? this.state,
      city: city ?? this.city,
      lattitude: lattitude ?? this.lattitude,
      longitude: longitude ?? this.longitude,
      is_agent: is_agent ?? this.is_agent,
      agent_status: agent_status ?? this.agent_status,
    );
  }

  Map<String, dynamic> takeDiff(UsersRecord other) {
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
        first_name,
        avatar,
        last_name,
        country,
        contact_info,
        location,
        state,
        city,
        lattitude,
        longitude,
        is_agent,
        agent_status,
      ];

  static Map<String, dynamic> forCreateRequest({
    required String username,
    required String email,
    required bool emailVisibility,
    required bool verified,
    String? first_name,
    String? avatar,
    String? last_name,
    String? country,
    double? contact_info,
    String? location,
    String? state,
    String? city,
    double? lattitude,
    double? longitude,
    bool? is_agent,
    UsersRecordAgent_statusEnum? agent_status,
  }) {
    final jsonMap = UsersRecord(
      id: '',
      created: _i5.EmptyDateTime(),
      updated: _i5.EmptyDateTime(),
      collectionId: $collectionId,
      collectionName: $collectionName,
      username: username,
      email: email,
      emailVisibility: emailVisibility,
      verified: verified,
      first_name: first_name,
      avatar: avatar,
      last_name: last_name,
      country: country,
      contact_info: contact_info,
      location: location,
      state: state,
      city: city,
      lattitude: lattitude,
      longitude: longitude,
      is_agent: is_agent,
      agent_status: agent_status,
    ).toJson();
    final Map<String, dynamic> result = {};
    result.addAll({
      UsersRecordFieldsEnum.username.name:
          jsonMap[UsersRecordFieldsEnum.username.name]
    });
    result.addAll({
      UsersRecordFieldsEnum.email.name:
          jsonMap[UsersRecordFieldsEnum.email.name]
    });
    result.addAll({
      UsersRecordFieldsEnum.emailVisibility.name:
          jsonMap[UsersRecordFieldsEnum.emailVisibility.name]
    });
    result.addAll({
      UsersRecordFieldsEnum.verified.name:
          jsonMap[UsersRecordFieldsEnum.verified.name]
    });
    if (first_name != null) {
      result.addAll({
        UsersRecordFieldsEnum.first_name.name:
            jsonMap[UsersRecordFieldsEnum.first_name.name]
      });
    }
    if (avatar != null) {
      result.addAll({
        UsersRecordFieldsEnum.avatar.name:
            jsonMap[UsersRecordFieldsEnum.avatar.name]
      });
    }
    if (last_name != null) {
      result.addAll({
        UsersRecordFieldsEnum.last_name.name:
            jsonMap[UsersRecordFieldsEnum.last_name.name]
      });
    }
    if (country != null) {
      result.addAll({
        UsersRecordFieldsEnum.country.name:
            jsonMap[UsersRecordFieldsEnum.country.name]
      });
    }
    if (contact_info != null) {
      result.addAll({
        UsersRecordFieldsEnum.contact_info.name:
            jsonMap[UsersRecordFieldsEnum.contact_info.name]
      });
    }
    if (location != null) {
      result.addAll({
        UsersRecordFieldsEnum.location.name:
            jsonMap[UsersRecordFieldsEnum.location.name]
      });
    }
    if (state != null) {
      result.addAll({
        UsersRecordFieldsEnum.state.name:
            jsonMap[UsersRecordFieldsEnum.state.name]
      });
    }
    if (city != null) {
      result.addAll({
        UsersRecordFieldsEnum.city.name:
            jsonMap[UsersRecordFieldsEnum.city.name]
      });
    }
    if (lattitude != null) {
      result.addAll({
        UsersRecordFieldsEnum.lattitude.name:
            jsonMap[UsersRecordFieldsEnum.lattitude.name]
      });
    }
    if (longitude != null) {
      result.addAll({
        UsersRecordFieldsEnum.longitude.name:
            jsonMap[UsersRecordFieldsEnum.longitude.name]
      });
    }
    if (is_agent != null) {
      result.addAll({
        UsersRecordFieldsEnum.is_agent.name:
            jsonMap[UsersRecordFieldsEnum.is_agent.name]
      });
    }
    if (agent_status != null) {
      result.addAll({
        UsersRecordFieldsEnum.agent_status.name:
            jsonMap[UsersRecordFieldsEnum.agent_status.name]
      });
    }
    return result;
  }
}
