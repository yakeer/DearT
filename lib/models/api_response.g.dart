// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

APIResponse<T> _$APIResponseFromJson<T>(
  Map<String, dynamic> json,
  Function fromJsonT,
) =>
    APIResponse<T>(
      fromJsonT(json['response']),
      json['count'] as int?,
      json['error'] as String?,
      json['error_description'] as String?,
    );
