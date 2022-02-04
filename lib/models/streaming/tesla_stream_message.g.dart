// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tesla_stream_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TeslaStreamMessage _$TeslaStreamMessageFromJson(Map<String, dynamic> json) =>
    TeslaStreamMessage(
      json['msg_type'] as String,
      tag: json['tag'] as String?,
      value: json['value'] as String?,
      token: json['token'] as String?,
      connectionTimeout: json['connection_timeout'] as int?,
      errorType: json['error_type'] as String?,
    );

Map<String, dynamic> _$TeslaStreamMessageToJson(TeslaStreamMessage instance) =>
    <String, dynamic>{
      'msg_type': instance.messageType,
      'value': instance.value,
      'tag': instance.tag,
      'token': instance.token,
      'connection_timeout': instance.connectionTimeout,
      'error_type': instance.errorType,
    };
