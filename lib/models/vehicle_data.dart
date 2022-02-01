import 'package:deart/models/charge_state.dart';
import 'package:deart/models/climate_state.dart';
import 'package:deart/models/vehicle_state.dart';
import 'package:json_annotation/json_annotation.dart';

part 'vehicle_data.g.dart';

@JsonSerializable(createToJson: false)
class VehicleData {
  @JsonKey(name: 'charge_state')
  final ChargeState chargeState;

  @JsonKey(name: 'vehicle_state')
  final VehicleState vehicleState;

  @JsonKey(name: 'climate_state')
  final ClimateState climateState;

  /// "online"
  final String state;

  VehicleData(
    this.chargeState,
    this.vehicleState,
    this.state,
    this.climateState,
  );

  factory VehicleData.fromJson(Map<String, dynamic> json) =>
      _$VehicleDataFromJson(json);
}
