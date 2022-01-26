import 'package:json_annotation/json_annotation.dart';

part 'climate_state.g.dart';

@JsonSerializable(createToJson: false)
class ClimateState {
  @JsonKey(name: 'inside_temp')
  final double insideTemp;

  @JsonKey(name: 'outside_temp')
  final double outsideTemp;

  @JsonKey(name: 'max_avail_temp')
  final double maxAvailableTemp;

  @JsonKey(name: 'min_avail_temp')
  final double minAvailableTemp;

  ClimateState(
    this.insideTemp,
    this.outsideTemp,
    this.maxAvailableTemp,
    this.minAvailableTemp,
  );

  factory ClimateState.fromJson(Map<String, dynamic> json) =>
      _$ClimateStateFromJson(json);
}
