// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'properties_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PropertiesRecord _$PropertiesRecordFromJson(Map<String, dynamic> json) =>
    PropertiesRecord(
      id: json['id'] as String,
      created: pocketBaseDateTimeFromJson(json['created'] as String),
      updated: pocketBaseDateTimeFromJson(json['updated'] as String),
      collectionId: json['collectionId'] as String,
      collectionName: json['collectionName'] as String,
      title: json['title'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      description: json['description'] as String?,
      location: json['location'] as String?,
      image:
          (json['image'] as List<dynamic>?)?.map((e) => e as String).toList(),
      type:
          $enumDecodeNullable(_$PropertiesRecordTypeEnumEnumMap, json['type']),
      listing_type: (json['listing_type'] as List<dynamic>?)
          ?.map(
              (e) => $enumDecode(_$PropertiesRecordListing_typeEnumEnumMap, e))
          .toList(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      latitude: (json['latitude'] as num?)?.toDouble(),
      is_featured: json['is_featured'] as bool?,
      is_booked: json['is_booked'] as bool?,
      booked_by: json['booked_by'] as String?,
      booking_date:
          pocketBaseNullableDateTimeFromJson(json['booking_date'] as String),
      country: json['country'] as String?,
      state: json['state'] as String?,
      city: json['city'] as String?,
      views: (json['views'] as num?)?.toDouble(),
      agent: json['agent'] as String?,
      bookings: (json['bookings'] as num?)?.toDouble(),
      status: $enumDecodeNullable(
          _$PropertiesRecordStatusEnumEnumMap, json['status']),
    );

Map<String, dynamic> _$PropertiesRecordToJson(PropertiesRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created': pocketBaseDateTimeToJson(instance.created),
      'updated': pocketBaseDateTimeToJson(instance.updated),
      'collectionId': instance.collectionId,
      'collectionName': instance.collectionName,
      'title': instance.title,
      'price': instance.price,
      'description': instance.description,
      'location': instance.location,
      'image': instance.image,
      'type': _$PropertiesRecordTypeEnumEnumMap[instance.type],
      'listing_type': instance.listing_type
          ?.map((e) => _$PropertiesRecordListing_typeEnumEnumMap[e]!)
          .toList(),
      'longitude': instance.longitude,
      'latitude': instance.latitude,
      'is_featured': instance.is_featured,
      'is_booked': instance.is_booked,
      'booked_by': instance.booked_by,
      'booking_date': pocketBaseNullableDateTimeToJson(instance.booking_date),
      'country': instance.country,
      'state': instance.state,
      'city': instance.city,
      'views': instance.views,
      'agent': instance.agent,
      'bookings': instance.bookings,
      'status': _$PropertiesRecordStatusEnumEnumMap[instance.status],
    };

const _$PropertiesRecordTypeEnumEnumMap = {
  PropertiesRecordTypeEnum.resident: 'resident',
  PropertiesRecordTypeEnum.office: 'office',
  PropertiesRecordTypeEnum.business: 'business',
};

const _$PropertiesRecordListing_typeEnumEnumMap = {
  PropertiesRecordListing_typeEnum.rent: 'rent',
  PropertiesRecordListing_typeEnum.sale: 'sale',
  PropertiesRecordListing_typeEnum.lease: 'lease',
};

const _$PropertiesRecordStatusEnumEnumMap = {
  PropertiesRecordStatusEnum.available: 'available',
  PropertiesRecordStatusEnum.sold: 'sold',
  PropertiesRecordStatusEnum.booked: 'booked',
};
