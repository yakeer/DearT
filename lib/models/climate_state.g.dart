// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'climate_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClimateState _$ClimateStateFromJson(Map<String, dynamic> json) => ClimateState(
      (json['inside_temp'] as num).toDouble(),
      (json['outside_temp'] as num).toDouble(),
      (json['max_avail_temp'] as num).toDouble(),
      (json['min_avail_temp'] as num).toDouble(),
      (json['driver_temp_setting'] as num).toDouble(),
      (json['passenger_temp_setting'] as num).toDouble(),
      json['is_preconditioning'] as bool,
      json['is_climate_on'] as bool,
      json['is_auto_conditioning_on'] as bool,
      json['seat_heater_left'] as int?,
      json['seat_heater_right'] as int?,
      json['seat_heater_rear_left'] as int?,
      json['seat_heater_rear_center'] as int?,
      json['seat_heater_rear_right'] as int?,
      json['steering_wheel_heater'] as bool?,
    );

Map<String, dynamic> _$ClimateStateToJson(ClimateState instance) =>
    <String, dynamic>{
      'inside_temp': instance.insideTemp,
      'outside_temp': instance.outsideTemp,
      'max_avail_temp': instance.maxAvailableTemp,
      'min_avail_temp': instance.minAvailableTemp,
      'driver_temp_setting': instance.driverTempSetting,
      'passenger_temp_setting': instance.passengerTempSetting,
      'is_preconditioning': instance.isPreconditioning,
      'is_climate_on': instance.isClimateOn,
      'is_auto_conditioning_on': instance.isAutoConditioningOn,
      'seat_heater_left': instance.seatHeaterLeft,
      'seat_heater_right': instance.seatHeaterRight,
      'seat_heater_rear_left': instance.seatHeaterRearLeft,
      'seat_heater_rear_center': instance.seatHeaterRearCenter,
      'seat_heater_rear_right': instance.seatHeaterRearRight,
      'steering_wheel_heater': instance.steeringWheelHeater,
    };
