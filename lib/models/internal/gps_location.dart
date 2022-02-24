import 'package:json_annotation/json_annotation.dart';

part 'gps_location.g.dart';

@JsonSerializable()
class GPSLocation {
  final String id;
  String name;
  double latitude;
  double longitude;
  double? radius;

  GPSLocation(
    this.id,
    this.latitude,
    this.longitude,
    this.name, {
    this.radius,
  });

  factory GPSLocation.fromJson(Map<String, dynamic> json) =>
      _$GPSLocationFromJson(json);

  Map<String, dynamic> toJson() => _$GPSLocationToJson(this);

  static List<GPSLocation> fromJsonList(List<dynamic> jsonList) {
    List<GPSLocation> result = [];

    for (var element in jsonList) {
      result.add(GPSLocation.fromJson(element));
    }

    return result;
  }
}
