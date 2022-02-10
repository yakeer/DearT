// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drive_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DriveState _$DriveStateFromJson(Map<String, dynamic> json) => DriveState(
      (json['latitude'] as num).toDouble(),
      (json['longitude'] as num).toDouble(),
      json['shift_state'] as String?,
      json['speed'] as int?,
      json['power'] as int?,
    );

Map<String, dynamic> _$DriveStateToJson(DriveState instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'shift_state': instance.shiftState,
      'speed': instance.speed,
      'power': instance.power,
    };
