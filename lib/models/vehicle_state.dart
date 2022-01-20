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

  VehicleState(this.locked, this.odometer, this.dashcamState, this.carVersion);

  factory VehicleState.fromJson(Map<String, dynamic> json) =>
      _$VehicleStateFromJson(json);
}
