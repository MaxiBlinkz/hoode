// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'property.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Property _$PropertyFromJson(Map<String, dynamic> json) => Property(
      id: json['id'] as String,
      title: json['title'] as String,
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String,
      location: json['location'] as String,
      image: json['image'] as String,
      viewCount: (json['viewCount'] as num).toInt(),
      favoriteCount: (json['favoriteCount'] as num).toInt(),
      rating: (json['rating'] as num).toDouble(),
      category: json['category'] as String,
      bathrooms: (json['bathrooms'] as num).toInt(),
      bedrooms: (json['bedrooms'] as num).toInt(),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );

Map<String, dynamic> _$PropertyToJson(Property instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'price': instance.price,
      'description': instance.description,
      'location': instance.location,
      'image': instance.image,
      'viewCount': instance.viewCount,
      'favoriteCount': instance.favoriteCount,
      'rating': instance.rating,
      'category': instance.category,
      'bathrooms': instance.bathrooms,
      'bedrooms': instance.bedrooms,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };
