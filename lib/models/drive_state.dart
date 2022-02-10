import 'package:json_annotation/json_annotation.dart';

part 'drive_state.g.dart';

@JsonSerializable()
class DriveState {
  @JsonKey(name: 'latitude')
  final double latitude;

  @JsonKey(name: 'longitude')
  final double longitude;

  @JsonKey(name: 'shift_state')
  final String? shiftState;

  @JsonKey(name: 'speed')
  final int? speed;

  @JsonKey(name: 'power')
  final int? power;

  DriveState(
    this.latitude,
    this.longitude,
    this.shiftState,
    this.speed,
    this.power,
  );

  factory DriveState.fromJson(Map<String, dynamic> json) =>
      _$DriveStateFromJson(json);

  Map<String, dynamic> toJson() => _$DriveStateToJson(this);
}
