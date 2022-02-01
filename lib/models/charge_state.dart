import 'package:json_annotation/json_annotation.dart';

part 'charge_state.g.dart';

@JsonSerializable(createToJson: false)
class ChargeState {
  @JsonKey(name: 'battery_level')
  final int batteryLevel;

  @JsonKey(name: 'battery_range')
  final double batteryRange;

  @JsonKey(name: 'charge_port_door_open')
  final bool chargePortDoorOpen;

  /// "Stopped", "Charging"
  @JsonKey(name: 'charging_state')
  final String chargingState;

  @JsonKey(name: 'charger_actual_current')
  final int? chargerActualCurrent;

  @JsonKey(name: 'charge_current_request')
  final int chargeCurrentRequest;

  @JsonKey(name: 'charge_current_request_max')
  final int chargeCurrentRequestMax;

  @JsonKey(name: 'charger_pilot_current')
  final int? chargerPilotCurrent;

  /// "Engaged", "Disengaged"
  @JsonKey(name: 'charge_port_latch')
  final String chargePortLatch;

  ChargeState(
    this.batteryLevel,
    this.batteryRange,
    this.chargePortDoorOpen,
    this.chargingState,
    this.chargerActualCurrent,
    this.chargeCurrentRequest,
    this.chargeCurrentRequestMax,
    this.chargerPilotCurrent,
    this.chargePortLatch,
  );

  factory ChargeState.fromJson(Map<String, dynamic> json) =>
      _$ChargeStateFromJson(json);
}
