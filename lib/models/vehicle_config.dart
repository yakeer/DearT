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

  VehicleConfig(
    this.carType,
    this.exteriorColor,
    this.interiorTrimType,
  );

  factory VehicleConfig.fromJson(Map<String, dynamic> json) =>
      _$VehicleConfigFromJson(json);

  Map<String, dynamic> toJson() => _$VehicleConfigToJson(this);
}
