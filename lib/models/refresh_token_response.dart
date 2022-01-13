import 'package:json_annotation/json_annotation.dart';

part 'refresh_token_response.g.dart';

@JsonSerializable(createToJson: false)
class RefreshTokenResponse {
  @JsonKey(name: 'access_token')
  final String? accessToken;

  @JsonKey(name: 'refresh_token')
  final String? refreshToken;

  @JsonKey(name: 'id_token')
  final String? idToken;

  @JsonKey(name: 'expires_in')
  final int? expiresIn;

  @JsonKey(name: 'state')
  final String? state;

  @JsonKey(name: 'token_type')
  final String? tokenType;

  RefreshTokenResponse(
    this.accessToken,
    this.refreshToken,
    this.idToken,
    this.expiresIn,
    this.state,
    this.tokenType,
  );

  factory RefreshTokenResponse.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenResponseFromJson(json);
}
