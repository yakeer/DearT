import 'package:json_annotation/json_annotation.dart';

part 'vehicle_state.g.dart';

@JsonSerializable(createToJson: false)
class VehicleState {
  final bool locked;

  final double odometer;

  @JsonKey(name: 'dashcam_state')
  final String dashcamState;

  @JsonKey(name: 'car_version')
  final String carVersion;

  @JsonKey(name: 'ft')
  final int frontTrunk;

  @JsonKey(name: 'rt')
  final int rearTrunk;

  VehicleState(this.locked, this.odometer, this.dashcamState, this.carVersion,
      this.rearTrunk, this.frontTrunk);

  factory VehicleState.fromJson(Map<String, dynamic> json) =>
      _$VehicleStateFromJson(json);
}
