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
    );
