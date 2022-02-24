// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VehicleData _$VehicleDataFromJson(Map<String, dynamic> json) => VehicleData(
      DriveState.fromJson(json['drive_state'] as Map<String, dynamic>),
      ChargeState.fromJson(json['charge_state'] as Map<String, dynamic>),
      VehicleState.fromJson(json['vehicle_state'] as Map<String, dynamic>),
      json['state'] as String,
      ClimateState.fromJson(json['climate_state'] as Map<String, dynamic>),
      VehicleConfig.fromJson(json['vehicle_config'] as Map<String, dynamic>),
      json['display_name'] as String,
    );

Map<String, dynamic> _$VehicleDataToJson(VehicleData instance) =>
    <String, dynamic>{
      'drive_state': instance.driveState,
      'charge_state': instance.chargeState,
      'vehicle_state': instance.vehicleState,
      'climate_state': instance.climateState,
      'vehicle_config': instance.vehicleConfig,
      'state': instance.state,
      'display_name': instance.displayName,
    };
