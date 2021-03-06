import 'package:json_annotation/json_annotation.dart';

part 'charge_state.g.dart';

@JsonSerializable()
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

  @JsonKey(name: 'time_to_full_charge')
  final double timeToFullCharge;

  @JsonKey(name: 'charge_limit_soc')
  final int chargeLimitSoc;

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
    this.timeToFullCharge,
    this.chargeLimitSoc,
  );

  factory ChargeState.fromJson(Map<String, dynamic> json) =>
      _$ChargeStateFromJson(json);

  Map<String, dynamic> toJson() => _$ChargeStateToJson(this);
}
