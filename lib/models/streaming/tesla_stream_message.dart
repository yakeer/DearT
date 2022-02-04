import 'package:json_annotation/json_annotation.dart';

part 'tesla_stream_message.g.dart';

@JsonSerializable()
class TeslaStreamMessage {
  @JsonKey(name: 'msg_type')
  final String messageType;

  final String? value;

  final String? tag;

  final String? token;

  @JsonKey(name: 'connection_timeout')
  final int? connectionTimeout;

  @JsonKey(name: 'error_type')
  final String? errorType;

  TeslaStreamMessage(
    this.messageType, {
    this.tag,
    this.value,
    this.token,
    this.connectionTimeout,
    this.errorType,
  });

  factory TeslaStreamMessage.fromJson(Map<String, dynamic> json) =>
      _$TeslaStreamMessageFromJson(json);

  Map<String, dynamic> toJson() => _$TeslaStreamMessageToJson(this);
}
