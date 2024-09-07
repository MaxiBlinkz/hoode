// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'property.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Property _$PropertyFromJson(Map<String, dynamic> json) => Property(
      property_id: json['property_id'] as String,
      agent_id: json['agent_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      price: json['price'] as String,
      location: json['location'] as String,
      latitude: json['latitude'] as String,
      longitude: json['longitude'] as String,
      property_type: json['property_type'] as String,
      status: json['status'] as String,
      created_at: json['created_at'] as String,
      updated_at: json['updated_at'] as String,
      image_url: json['image_url'] as String,
      featured: json['featured'] as bool,
    );

Map<String, dynamic> _$PropertyToJson(Property instance) => <String, dynamic>{
      'property_id': instance.property_id,
      'agent_id': instance.agent_id,
      'title': instance.title,
      'description': instance.description,
      'price': instance.price,
      'location': instance.location,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'property_type': instance.property_type,
      'status': instance.status,
      'created_at': instance.created_at,
      'updated_at': instance.updated_at,
      'image_url': instance.image_url,
      'featured': instance.featured,
    };
