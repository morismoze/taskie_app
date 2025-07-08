import 'package:json_annotation/json_annotation.dart';

part 'refresh_token_response.g.dart';

@JsonSerializable()
class RefreshTokenResponse {
  RefreshTokenResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenExpires,
  });

  final String accessToken;
  final String refreshToken;
  final int tokenExpires;

  factory RefreshTokenResponse.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenResponseFromJson(json);
}
