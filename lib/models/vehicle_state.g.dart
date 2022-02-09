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
      json['is_user_present'] as bool,
    );

Map<String, dynamic> _$VehicleStateToJson(VehicleState instance) =>
    <String, dynamic>{
      'locked': instance.locked,
      'odometer': instance.odometer,
      'dashcam_state': instance.dashcamState,
      'car_version': instance.carVersion,
      'ft': instance.frontTrunk,
      'rt': instance.rearTrunk,
      'fd_window': instance.frontDriverWindow,
      'fp_window': instance.frontPassengerWindow,
      'rd_window': instance.rearDriverWindow,
      'rp_window': instance.rearPassengerWindow,
      'df': instance.frontDriverDoor,
      'pf': instance.frontPassengerDoor,
      'dr': instance.rearDriverDoor,
      'pr': instance.rearPassengerDoor,
      'is_user_present': instance.isUserPresent,
    };
