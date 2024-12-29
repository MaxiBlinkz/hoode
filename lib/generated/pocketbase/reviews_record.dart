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

part 'reviews_record.g.dart';

enum ReviewsRecordFieldsEnum {
  id,
  created,
  updated,
  collectionId,
  collectionName,
  user,
  property,
  rating,
  content
}

@_i1.JsonSerializable()
final class ReviewsRecord extends _i2.BaseRecord {
  ReviewsRecord({
    required super.id,
    required super.created,
    required super.updated,
    required super.collectionId,
    required super.collectionName,
    this.user,
    this.property,
    this.rating,
    this.content,
  });

  factory ReviewsRecord.fromJson(Map<String, dynamic> json) =>
      _$ReviewsRecordFromJson(json);

  factory ReviewsRecord.fromRecordModel(_i3.RecordModel recordModel) {
    final extendedJsonMap = {
      ...recordModel.data,
      ReviewsRecordFieldsEnum.id.name: recordModel.id,
      ReviewsRecordFieldsEnum.created.name: recordModel.created,
      ReviewsRecordFieldsEnum.updated.name: recordModel.updated,
      ReviewsRecordFieldsEnum.collectionId.name: recordModel.collectionId,
      ReviewsRecordFieldsEnum.collectionName.name: recordModel.collectionName,
    };
    return ReviewsRecord.fromJson(extendedJsonMap);
  }

  final String? user;

  final String? property;

  final double? rating;

  static const ratingMinValue = 0;

  static const ratingMaxValue = 5;

  final String? content;

  static const $collectionId = 'v543o456xhhs22l';

  static const $collectionName = 'reviews';

  Map<String, dynamic> toJson() => _$ReviewsRecordToJson(this);

  ReviewsRecord copyWith({
    String? user,
    String? property,
    double? rating,
    String? content,
  }) {
    return ReviewsRecord(
      id: id,
      created: created,
      updated: updated,
      collectionId: collectionId,
      collectionName: collectionName,
      user: user ?? this.user,
      property: property ?? this.property,
      rating: rating ?? this.rating,
      content: content ?? this.content,
    );
  }

  Map<String, dynamic> takeDiff(ReviewsRecord other) {
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
        rating,
        content,
      ];

  static Map<String, dynamic> forCreateRequest({
    String? user,
    String? property,
    double? rating,
    String? content,
  }) {
    final jsonMap = ReviewsRecord(
      id: '',
      created: _i5.EmptyDateTime(),
      updated: _i5.EmptyDateTime(),
      collectionId: $collectionId,
      collectionName: $collectionName,
      user: user,
      property: property,
      rating: rating,
      content: content,
    ).toJson();
    final Map<String, dynamic> result = {};
    if (user != null) {
      result.addAll({
        ReviewsRecordFieldsEnum.user.name:
            jsonMap[ReviewsRecordFieldsEnum.user.name]
      });
    }
    if (property != null) {
      result.addAll({
        ReviewsRecordFieldsEnum.property.name:
            jsonMap[ReviewsRecordFieldsEnum.property.name]
      });
    }
    if (rating != null) {
      result.addAll({
        ReviewsRecordFieldsEnum.rating.name:
            jsonMap[ReviewsRecordFieldsEnum.rating.name]
      });
    }
    if (content != null) {
      result.addAll({
        ReviewsRecordFieldsEnum.content.name:
            jsonMap[ReviewsRecordFieldsEnum.content.name]
      });
    }
    return result;
  }
}
