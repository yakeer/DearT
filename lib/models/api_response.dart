import 'package:json_annotation/json_annotation.dart';

part 'api_response.g.dart';

@JsonSerializable(genericArgumentFactories: true, createToJson: false)
class APIResponse<T> {
  @JsonKey()
  final T response;

  @JsonKey(includeIfNull: false)
  final String? error;

  @JsonKey(name: 'error_description', includeIfNull: false)
  final String? errorDescription;

  final int? count;

  APIResponse(this.response, this.count, this.error, this.errorDescription);

  factory APIResponse.fromJson(
    Map<String, dynamic> json,
    Function fromJsonT,
  ) {
    return _$APIResponseFromJson(json, fromJsonT);
  }
}
