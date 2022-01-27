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

  ChargeState(this.batteryLevel, this.batteryRange, this.chargePortDoorOpen);

  factory ChargeState.fromJson(Map<String, dynamic> json) =>
      _$ChargeStateFromJson(json);
}
