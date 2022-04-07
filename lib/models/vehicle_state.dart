import 'package:json_annotation/json_annotation.dart';

part 'vehicle_state.g.dart';

@JsonSerializable()
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

  @JsonKey(name: 'fd_window')
  final int frontDriverWindow;

  @JsonKey(name: 'fp_window')
  final int frontPassengerWindow;

  @JsonKey(name: 'rd_window')
  final int rearDriverWindow;

  @JsonKey(name: 'rp_window')
  final int rearPassengerWindow;

  @JsonKey(name: 'df')
  final int frontDriverDoor;

  @JsonKey(name: 'pf')
  final int frontPassengerDoor;

  @JsonKey(name: 'dr')
  final int rearDriverDoor;

  @JsonKey(name: 'pr')
  final int rearPassengerDoor;

  @JsonKey(name: 'is_user_present')
  final bool isUserPresent;

  @JsonKey(name: 'tpms_pressure_fl')
  final double tpmsFrontLeft;

  @JsonKey(name: 'tpms_pressure_fr')
  final double tpmsFrontRight;

  @JsonKey(name: 'tpms_pressure_rl')
  final double tpmsRearLeft;

  @JsonKey(name: 'tpms_pressure_rr')
  final double tpmsRearRight;

  final int timestamp;

  VehicleState(
    this.locked,
    this.odometer,
    this.dashcamState,
    this.carVersion,
    this.rearTrunk,
    this.frontTrunk,
    this.frontDriverWindow,
    this.frontPassengerWindow,
    this.rearDriverWindow,
    this.rearPassengerWindow,
    this.frontDriverDoor,
    this.frontPassengerDoor,
    this.rearDriverDoor,
    this.rearPassengerDoor,
    this.isUserPresent,
    this.timestamp,
    this.tpmsFrontLeft,
    this.tpmsFrontRight,
    this.tpmsRearLeft,
    this.tpmsRearRight,
  );

  factory VehicleState.fromJson(Map<String, dynamic> json) =>
      _$VehicleStateFromJson(json);

  Map<String, dynamic> toJson() => _$VehicleStateToJson(this);
}
