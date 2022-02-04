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
      json['fd_window'] as int,
      json['fp_window'] as int,
      json['rd_window'] as int,
      json['rp_window'] as int,
      json['df'] as int,
      json['pf'] as int,
      json['dr'] as int,
      json['pr'] as int,
    );
