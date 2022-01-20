import 'package:deart/models/charge_state.dart';
import 'package:deart/models/vehicle_state.dart';
import 'package:json_annotation/json_annotation.dart';

part 'vehicle_data.g.dart';

@JsonSerializable(createToJson: false)
class VehicleData {
  @JsonKey(name: 'charge_state')
  final ChargeState chargeState;

  @JsonKey(name: 'vehicle_state')
  final VehicleState vehicleState;

  final String state;

  VehicleData(this.chargeState, this.vehicleState, this.state);

  factory VehicleData.fromJson(Map<String, dynamic> json) =>
      _$VehicleDataFromJson(json);
}
