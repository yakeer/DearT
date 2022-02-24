// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gps_location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GPSLocation _$GPSLocationFromJson(Map<String, dynamic> json) => GPSLocation(
      json['id'] as String,
      (json['latitude'] as num).toDouble(),
      (json['longitude'] as num).toDouble(),
      json['name'] as String,
      radius: (json['radius'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$GPSLocationToJson(GPSLocation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'radius': instance.radius,
    };
