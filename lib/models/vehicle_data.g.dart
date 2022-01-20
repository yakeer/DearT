// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VehicleData _$VehicleDataFromJson(Map<String, dynamic> json) => VehicleData(
      ChargeState.fromJson(json['charge_state'] as Map<String, dynamic>),
      VehicleState.fromJson(json['vehicle_state'] as Map<String, dynamic>),
      json['state'] as String,
    );
