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

part 'agents_record.g.dart';

enum AgentsRecordFieldsEnum {
  id,
  created,
  updated,
  collectionId,
  collectionName,
  user,
  name,
  title,
  bio,
  specialization,
  licence,
  contact,
  avatar,
  ratings,
  total_bookings,
  total_listings
}

enum AgentsRecordSpecializationEnum {
  @_i1.JsonValue('residential')
  residential,
  @_i1.JsonValue('commercial')
  commercial,
  @_i1.JsonValue('luxury')
  luxury
}

@_i1.JsonSerializable()
final class AgentsRecord extends _i2.BaseRecord {
  AgentsRecord({
    required super.id,
    required super.created,
    required super.updated,
    required super.collectionId,
    required super.collectionName,
    this.user,
    this.name,
    this.title,
    this.bio,
    this.specialization,
    this.licence,
    this.contact,
    this.avatar,
    this.ratings,
    this.total_bookings,
    this.total_listings,
  });

  factory AgentsRecord.fromJson(Map<String, dynamic> json) =>
      _$AgentsRecordFromJson(json);

  factory AgentsRecord.fromRecordModel(_i3.RecordModel recordModel) {
    final extendedJsonMap = {
      ...recordModel.data,
      AgentsRecordFieldsEnum.id.name: recordModel.id,
      AgentsRecordFieldsEnum.created.name: recordModel.created,
      AgentsRecordFieldsEnum.updated.name: recordModel.updated,
      AgentsRecordFieldsEnum.collectionId.name: recordModel.collectionId,
      AgentsRecordFieldsEnum.collectionName.name: recordModel.collectionName,
    };
    return AgentsRecord.fromJson(extendedJsonMap);
  }

  final String? user;

  final String? name;

  final String? title;

  final String? bio;

  final AgentsRecordSpecializationEnum? specialization;

  final String? licence;

  final dynamic contact;

  final String? avatar;

  final double? ratings;

  final double? total_bookings;

  final double? total_listings;

  static const $collectionId = '2ieord0h167df1o';

  static const $collectionName = 'agents';

  Map<String, dynamic> toJson() => _$AgentsRecordToJson(this);

  AgentsRecord copyWith({
    String? user,
    String? name,
    String? title,
    String? bio,
    AgentsRecordSpecializationEnum? specialization,
    String? licence,
    dynamic contact,
    String? avatar,
    double? ratings,
    double? total_bookings,
    double? total_listings,
  }) {
    return AgentsRecord(
      id: id,
      created: created,
      updated: updated,
      collectionId: collectionId,
      collectionName: collectionName,
      user: user ?? this.user,
      name: name ?? this.name,
      title: title ?? this.title,
      bio: bio ?? this.bio,
      specialization: specialization ?? this.specialization,
      licence: licence ?? this.licence,
      contact: contact ?? this.contact,
      avatar: avatar ?? this.avatar,
      ratings: ratings ?? this.ratings,
      total_bookings: total_bookings ?? this.total_bookings,
      total_listings: total_listings ?? this.total_listings,
    );
  }

  Map<String, dynamic> takeDiff(AgentsRecord other) {
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
        name,
        title,
        bio,
        specialization,
        licence,
        contact,
        avatar,
        ratings,
        total_bookings,
        total_listings,
      ];

  static Map<String, dynamic> forCreateRequest({
    String? user,
    String? name,
    String? title,
    String? bio,
    AgentsRecordSpecializationEnum? specialization,
    String? licence,
    dynamic contact,
    String? avatar,
    double? ratings,
    double? total_bookings,
    double? total_listings,
  }) {
    final jsonMap = AgentsRecord(
      id: '',
      created: _i5.EmptyDateTime(),
      updated: _i5.EmptyDateTime(),
      collectionId: $collectionId,
      collectionName: $collectionName,
      user: user,
      name: name,
      title: title,
      bio: bio,
      specialization: specialization,
      licence: licence,
      contact: contact,
      avatar: avatar,
      ratings: ratings,
      total_bookings: total_bookings,
      total_listings: total_listings,
    ).toJson();
    final Map<String, dynamic> result = {};
    if (user != null) {
      result.addAll({
        AgentsRecordFieldsEnum.user.name:
            jsonMap[AgentsRecordFieldsEnum.user.name]
      });
    }
    if (name != null) {
      result.addAll({
        AgentsRecordFieldsEnum.name.name:
            jsonMap[AgentsRecordFieldsEnum.name.name]
      });
    }
    if (title != null) {
      result.addAll({
        AgentsRecordFieldsEnum.title.name:
            jsonMap[AgentsRecordFieldsEnum.title.name]
      });
    }
    if (bio != null) {
      result.addAll({
        AgentsRecordFieldsEnum.bio.name:
            jsonMap[AgentsRecordFieldsEnum.bio.name]
      });
    }
    if (specialization != null) {
      result.addAll({
        AgentsRecordFieldsEnum.specialization.name:
            jsonMap[AgentsRecordFieldsEnum.specialization.name]
      });
    }
    if (licence != null) {
      result.addAll({
        AgentsRecordFieldsEnum.licence.name:
            jsonMap[AgentsRecordFieldsEnum.licence.name]
      });
    }
    if (contact != null) {
      result.addAll({
        AgentsRecordFieldsEnum.contact.name:
            jsonMap[AgentsRecordFieldsEnum.contact.name]
      });
    }
    if (avatar != null) {
      result.addAll({
        AgentsRecordFieldsEnum.avatar.name:
            jsonMap[AgentsRecordFieldsEnum.avatar.name]
      });
    }
    if (ratings != null) {
      result.addAll({
        AgentsRecordFieldsEnum.ratings.name:
            jsonMap[AgentsRecordFieldsEnum.ratings.name]
      });
    }
    if (total_bookings != null) {
      result.addAll({
        AgentsRecordFieldsEnum.total_bookings.name:
            jsonMap[AgentsRecordFieldsEnum.total_bookings.name]
      });
    }
    if (total_listings != null) {
      result.addAll({
        AgentsRecordFieldsEnum.total_listings.name:
            jsonMap[AgentsRecordFieldsEnum.total_listings.name]
      });
    }
    return result;
  }
}
