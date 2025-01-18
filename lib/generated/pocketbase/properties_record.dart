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

part 'properties_record.g.dart';

enum PropertiesRecordFieldsEnum {
  id,
  created,
  updated,
  collectionId,
  collectionName,
  title,
  price,
  description,
  location,
  image,
  type,
  listing_type,
  longitude,
  latitude,
  is_featured,
  is_booked,
  booked_by,
  booking_date,
  country,
  state,
  city,
  views,
  agent,
  bookings,
  status
}

enum PropertiesRecordTypeEnum {
  @_i1.JsonValue('resident')
  resident,
  @_i1.JsonValue('office')
  office,
  @_i1.JsonValue('business')
  business
}

enum PropertiesRecordListing_typeEnum {
  @_i1.JsonValue('rent')
  rent,
  @_i1.JsonValue('sale')
  sale,
  @_i1.JsonValue('lease')
  lease
}

enum PropertiesRecordStatusEnum {
  @_i1.JsonValue('available')
  available,
  @_i1.JsonValue('sold')
  sold,
  @_i1.JsonValue('booked')
  booked
}

@_i1.JsonSerializable()
final class PropertiesRecord extends _i2.BaseRecord {
  PropertiesRecord({
    required super.id,
    required super.created,
    required super.updated,
    required super.collectionId,
    required super.collectionName,
    this.title,
    this.price,
    this.description,
    this.location,
    this.image,
    this.type,
    this.listing_type,
    this.longitude,
    this.latitude,
    this.is_featured,
    this.is_booked,
    this.booked_by,
    this.booking_date,
    this.country,
    this.state,
    this.city,
    this.views,
    this.agent,
    this.bookings,
    this.status,
  });

  factory PropertiesRecord.fromJson(Map<String, dynamic> json) =>
      _$PropertiesRecordFromJson(json);

  factory PropertiesRecord.fromRecordModel(_i3.RecordModel recordModel) {
    final extendedJsonMap = {
      ...recordModel.data,
      PropertiesRecordFieldsEnum.id.name: recordModel.id,
      PropertiesRecordFieldsEnum.created.name: recordModel.created,
      PropertiesRecordFieldsEnum.updated.name: recordModel.updated,
      PropertiesRecordFieldsEnum.collectionId.name: recordModel.collectionId,
      PropertiesRecordFieldsEnum.collectionName.name:
          recordModel.collectionName,
    };
    return PropertiesRecord.fromJson(extendedJsonMap);
  }

  final String? title;

  final double? price;

  final String? description;

  final String? location;

  final List<String>? image;

  final PropertiesRecordTypeEnum? type;

  final List<PropertiesRecordListing_typeEnum>? listing_type;

  final double? longitude;

  final double? latitude;

  final bool? is_featured;

  final bool? is_booked;

  final String? booked_by;

  @_i1.JsonKey(
    toJson: pocketBaseNullableDateTimeToJson,
    fromJson: pocketBaseNullableDateTimeFromJson,
  )
  final DateTime? booking_date;

  final String? country;

  final String? state;

  final String? city;

  final double? views;

  final String? agent;

  final double? bookings;

  final PropertiesRecordStatusEnum? status;

  static const $collectionId = '7xcolsy6lhmocdt';

  static const $collectionName = 'properties';

  Map<String, dynamic> toJson() => _$PropertiesRecordToJson(this);

  PropertiesRecord copyWith({
    String? title,
    double? price,
    String? description,
    String? location,
    List<String>? image,
    PropertiesRecordTypeEnum? type,
    List<PropertiesRecordListing_typeEnum>? listing_type,
    double? longitude,
    double? latitude,
    bool? is_featured,
    bool? is_booked,
    String? booked_by,
    DateTime? booking_date,
    String? country,
    String? state,
    String? city,
    double? views,
    String? agent,
    double? bookings,
    PropertiesRecordStatusEnum? status,
  }) {
    return PropertiesRecord(
      id: id,
      created: created,
      updated: updated,
      collectionId: collectionId,
      collectionName: collectionName,
      title: title ?? this.title,
      price: price ?? this.price,
      description: description ?? this.description,
      location: location ?? this.location,
      image: image ?? this.image,
      type: type ?? this.type,
      listing_type: listing_type ?? this.listing_type,
      longitude: longitude ?? this.longitude,
      latitude: latitude ?? this.latitude,
      is_featured: is_featured ?? this.is_featured,
      is_booked: is_booked ?? this.is_booked,
      booked_by: booked_by ?? this.booked_by,
      booking_date: booking_date ?? this.booking_date,
      country: country ?? this.country,
      state: state ?? this.state,
      city: city ?? this.city,
      views: views ?? this.views,
      agent: agent ?? this.agent,
      bookings: bookings ?? this.bookings,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> takeDiff(PropertiesRecord other) {
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
        title,
        price,
        description,
        location,
        image,
        type,
        listing_type,
        longitude,
        latitude,
        is_featured,
        is_booked,
        booked_by,
        booking_date,
        country,
        state,
        city,
        views,
        agent,
        bookings,
        status,
      ];

  static Map<String, dynamic> forCreateRequest({
    String? title,
    double? price,
    String? description,
    String? location,
    List<String>? image,
    PropertiesRecordTypeEnum? type,
    List<PropertiesRecordListing_typeEnum>? listing_type,
    double? longitude,
    double? latitude,
    bool? is_featured,
    bool? is_booked,
    String? booked_by,
    DateTime? booking_date,
    String? country,
    String? state,
    String? city,
    double? views,
    String? agent,
    double? bookings,
    PropertiesRecordStatusEnum? status,
  }) {
    final jsonMap = PropertiesRecord(
      id: '',
      created: _i5.EmptyDateTime(),
      updated: _i5.EmptyDateTime(),
      collectionId: $collectionId,
      collectionName: $collectionName,
      title: title,
      price: price,
      description: description,
      location: location,
      image: image,
      type: type,
      listing_type: listing_type,
      longitude: longitude,
      latitude: latitude,
      is_featured: is_featured,
      is_booked: is_booked,
      booked_by: booked_by,
      booking_date: booking_date,
      country: country,
      state: state,
      city: city,
      views: views,
      agent: agent,
      bookings: bookings,
      status: status,
    ).toJson();
    final Map<String, dynamic> result = {};
    if (title != null) {
      result.addAll({
        PropertiesRecordFieldsEnum.title.name:
            jsonMap[PropertiesRecordFieldsEnum.title.name]
      });
    }
    if (price != null) {
      result.addAll({
        PropertiesRecordFieldsEnum.price.name:
            jsonMap[PropertiesRecordFieldsEnum.price.name]
      });
    }
    if (description != null) {
      result.addAll({
        PropertiesRecordFieldsEnum.description.name:
            jsonMap[PropertiesRecordFieldsEnum.description.name]
      });
    }
    if (location != null) {
      result.addAll({
        PropertiesRecordFieldsEnum.location.name:
            jsonMap[PropertiesRecordFieldsEnum.location.name]
      });
    }
    if (image != null) {
      result.addAll({
        PropertiesRecordFieldsEnum.image.name:
            jsonMap[PropertiesRecordFieldsEnum.image.name]
      });
    }
    if (type != null) {
      result.addAll({
        PropertiesRecordFieldsEnum.type.name:
            jsonMap[PropertiesRecordFieldsEnum.type.name]
      });
    }
    if (listing_type != null) {
      result.addAll({
        PropertiesRecordFieldsEnum.listing_type.name:
            jsonMap[PropertiesRecordFieldsEnum.listing_type.name]
      });
    }
    if (longitude != null) {
      result.addAll({
        PropertiesRecordFieldsEnum.longitude.name:
            jsonMap[PropertiesRecordFieldsEnum.longitude.name]
      });
    }
    if (latitude != null) {
      result.addAll({
        PropertiesRecordFieldsEnum.latitude.name:
            jsonMap[PropertiesRecordFieldsEnum.latitude.name]
      });
    }
    if (is_featured != null) {
      result.addAll({
        PropertiesRecordFieldsEnum.is_featured.name:
            jsonMap[PropertiesRecordFieldsEnum.is_featured.name]
      });
    }
    if (is_booked != null) {
      result.addAll({
        PropertiesRecordFieldsEnum.is_booked.name:
            jsonMap[PropertiesRecordFieldsEnum.is_booked.name]
      });
    }
    if (booked_by != null) {
      result.addAll({
        PropertiesRecordFieldsEnum.booked_by.name:
            jsonMap[PropertiesRecordFieldsEnum.booked_by.name]
      });
    }
    if (booking_date != null) {
      result.addAll({
        PropertiesRecordFieldsEnum.booking_date.name:
            jsonMap[PropertiesRecordFieldsEnum.booking_date.name]
      });
    }
    if (country != null) {
      result.addAll({
        PropertiesRecordFieldsEnum.country.name:
            jsonMap[PropertiesRecordFieldsEnum.country.name]
      });
    }
    if (state != null) {
      result.addAll({
        PropertiesRecordFieldsEnum.state.name:
            jsonMap[PropertiesRecordFieldsEnum.state.name]
      });
    }
    if (city != null) {
      result.addAll({
        PropertiesRecordFieldsEnum.city.name:
            jsonMap[PropertiesRecordFieldsEnum.city.name]
      });
    }
    if (views != null) {
      result.addAll({
        PropertiesRecordFieldsEnum.views.name:
            jsonMap[PropertiesRecordFieldsEnum.views.name]
      });
    }
    if (agent != null) {
      result.addAll({
        PropertiesRecordFieldsEnum.agent.name:
            jsonMap[PropertiesRecordFieldsEnum.agent.name]
      });
    }
    if (bookings != null) {
      result.addAll({
        PropertiesRecordFieldsEnum.bookings.name:
            jsonMap[PropertiesRecordFieldsEnum.bookings.name]
      });
    }
    if (status != null) {
      result.addAll({
        PropertiesRecordFieldsEnum.status.name:
            jsonMap[PropertiesRecordFieldsEnum.status.name]
      });
    }
    return result;
  }
}
