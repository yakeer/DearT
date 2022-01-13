// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Vehicle _$VehicleFromJson(Map<String, dynamic> json) => Vehicle(
      json['id'] as int,
      json['vehicle_id'] as int,
      json['display_name'] as String,
      json['vin'] as String,
      json['state'] as String,
    );

Map<String, dynamic> _$VehicleToJson(Vehicle instance) => <String, dynamic>{
      'id': instance.id,
      'vehicle_id': instance.vehicleId,
      'display_name': instance.displayName,
      'vin': instance.vin,
      'state': instance.state,
    };
