import 'package:json_annotation/json_annotation.dart';

part 'drive_state.g.dart';

@JsonSerializable(createToJson: false)
class DriveState {
  @JsonKey(name: 'latitude')
  final double latitude;

  @JsonKey(name: 'longitude')
  final double longitude;

  DriveState(
    this.latitude,
    this.longitude,
  );

  factory DriveState.fromJson(Map<String, dynamic> json) =>
      _$DriveStateFromJson(json);
}
