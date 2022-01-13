import 'package:json_annotation/json_annotation.dart';

part 'command_result.g.dart';

@JsonSerializable(createToJson: false)
class CommandResult {
  final String? reason;
  final bool result;

  CommandResult(this.reason, this.result);

  factory CommandResult.fromJson(Map<String, dynamic> json) =>
      _$CommandResultFromJson(json);
}
