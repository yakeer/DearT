import 'package:json_annotation/json_annotation.dart';

part 'vehicle.g.dart';

@JsonSerializable()
class Vehicle {
  final int id;

  @JsonKey(name: 'vehicle_id')
  final int vehicleId;

  @JsonKey(name: 'display_name')
  final String displayName;
  final String vin;
  final String state;

  Vehicle(this.id, this.vehicleId, this.displayName, this.vin, this.state);

  factory Vehicle.fromJson(Map<String, dynamic> json) =>
      _$VehicleFromJson(json);

  static List<Vehicle> fromJsonList(List<dynamic> jsonList) {
    List<Vehicle> result = [];

    for (var element in jsonList) {
      result.add(Vehicle.fromJson(element));
    }

    return result;
  }

  Map<String, dynamic> toJson() => _$VehicleToJson(this);
}
