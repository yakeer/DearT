// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VehicleState _$VehicleStateFromJson(Map<String, dynamic> json) => VehicleState(
      json['locked'] as bool,
      (json['odometer'] as num).toDouble(),
      json['dashcam_state'] as String,
      json['car_version'] as String,
      json['rt'] as int,
      json['ft'] as int,
    );
