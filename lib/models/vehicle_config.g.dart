// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VehicleConfig _$VehicleConfigFromJson(Map<String, dynamic> json) =>
    VehicleConfig(
      json['car_type'] as String,
      json['exterior_color'] as String,
      json['interior_trim_type'] as String,
      json['rear_seat_heaters'] as int? ?? 1,
    );

Map<String, dynamic> _$VehicleConfigToJson(VehicleConfig instance) =>
    <String, dynamic>{
      'car_type': instance.carType,
      'exterior_color': instance.exteriorColor,
      'interior_trim_type': instance.interiorTrimType,
      'rear_seat_heaters': instance.rearSeatHeaters,
    };
