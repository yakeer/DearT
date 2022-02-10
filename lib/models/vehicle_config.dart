import 'package:json_annotation/json_annotation.dart';

part 'vehicle_config.g.dart';

@JsonSerializable()
class VehicleConfig {
  @JsonKey(name: 'car_type')
  final String carType;

  @JsonKey(name: 'exterior_color')
  final String exteriorColor;

  @JsonKey(name: 'interior_trim_type')
  final String interiorTrimType;

  @JsonKey(name: 'rear_seat_heaters', defaultValue: 1)
  final int rearSeatHeaters;

  VehicleConfig(
    this.carType,
    this.exteriorColor,
    this.interiorTrimType,
    this.rearSeatHeaters,
  );

  factory VehicleConfig.fromJson(Map<String, dynamic> json) =>
      _$VehicleConfigFromJson(json);

  Map<String, dynamic> toJson() => _$VehicleConfigToJson(this);
}
