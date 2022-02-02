import 'package:json_annotation/json_annotation.dart';

part 'climate_state.g.dart';

@JsonSerializable(createToJson: false)
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
  );

  factory ClimateState.fromJson(Map<String, dynamic> json) =>
      _$ClimateStateFromJson(json);
}
