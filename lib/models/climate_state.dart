import 'package:json_annotation/json_annotation.dart';

part 'climate_state.g.dart';

@JsonSerializable()
class ClimateState {
  @JsonKey(name: 'inside_temp')
  final double insideTemp;

  @JsonKey(name: 'outside_temp')
  final double outsideTemp;

  @JsonKey(name: 'max_avail_temp')
  final double maxAvailableTemp;

  @JsonKey(name: 'min_avail_temp')
  final double minAvailableTemp;

  @JsonKey(name: 'driver_temp_setting')
  final double driverTempSetting;

  @JsonKey(name: 'passenger_temp_setting')
  final double passengerTempSetting;

  @JsonKey(name: 'is_preconditioning')
  final bool isPreconditioning;

  @JsonKey(name: 'is_climate_on')
  final bool isClimateOn;

  @JsonKey(name: 'is_auto_conditioning_on')
  final bool isAutoConditioningOn;

  @JsonKey(name: 'seat_heater_left')
  final int? seatHeaterLeft;

  @JsonKey(name: 'seat_heater_right')
  final int? seatHeaterRight;

  @JsonKey(name: 'seat_heater_rear_left')
  final int? seatHeaterRearLeft;

  @JsonKey(name: 'seat_heater_rear_center')
  final int? seatHeaterRearCenter;

  @JsonKey(name: 'seat_heater_rear_right')
  final int? seatHeaterRearRight;

  //steering_wheel_heater
  @JsonKey(name: 'steering_wheel_heater')
  final bool? steeringWheelHeater;

  ClimateState(
    this.insideTemp,
    this.outsideTemp,
    this.maxAvailableTemp,
    this.minAvailableTemp,
    this.driverTempSetting,
    this.passengerTempSetting,
    this.isPreconditioning,
    this.isClimateOn,
    this.isAutoConditioningOn,
    this.seatHeaterLeft,
    this.seatHeaterRight,
    this.seatHeaterRearLeft,
    this.seatHeaterRearCenter,
    this.seatHeaterRearRight,
    this.steeringWheelHeater,
  );

  factory ClimateState.fromJson(Map<String, dynamic> json) =>
      _$ClimateStateFromJson(json);

  Map<String, dynamic> toJson() => _$ClimateStateToJson(this);
}
