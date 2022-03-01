import 'package:deart/models/charge_state.dart';
import 'package:deart/models/climate_state.dart';
import 'package:deart/models/drive_state.dart';
import 'package:deart/models/vehicle_config.dart';
import 'package:deart/models/vehicle_state.dart';
import 'package:json_annotation/json_annotation.dart';

part 'vehicle_data.g.dart';

@JsonSerializable()
class VehicleData {
  @JsonKey(name: 'drive_state')
  final DriveState driveState;

  @JsonKey(name: 'charge_state')
  final ChargeState chargeState;

  @JsonKey(name: 'vehicle_state')
  final VehicleState vehicleState;

  @JsonKey(name: 'climate_state')
  final ClimateState climateState;

  @JsonKey(name: 'vehicle_config')
  final VehicleConfig vehicleConfig;

  /// "online"
  final String state;

  @JsonKey(name: 'display_name')
  final String displayName;

  VehicleData(
    this.driveState,
    this.chargeState,
    this.vehicleState,
    this.state,
    this.climateState,
    this.vehicleConfig,
    this.displayName,
  );

  factory VehicleData.fromJson(Map<String, dynamic> json) =>
      _$VehicleDataFromJson(json);

  Map<String, dynamic> toJson() => _$VehicleDataToJson(this);
}
