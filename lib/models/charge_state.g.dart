// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'charge_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChargeState _$ChargeStateFromJson(Map<String, dynamic> json) => ChargeState(
      json['battery_level'] as int,
      (json['battery_range'] as num).toDouble(),
      json['charge_port_door_open'] as bool,
      json['charging_state'] as String,
      json['charger_actual_current'] as int?,
      json['charge_current_request'] as int,
      json['charge_current_request_max'] as int,
      json['charger_pilot_current'] as int?,
      json['charge_port_latch'] as String,
      (json['time_to_full_charge'] as num).toDouble(),
    );
