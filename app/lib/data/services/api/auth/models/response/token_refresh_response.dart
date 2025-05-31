import 'package:json_annotation/json_annotation.dart';

part 'token_refresh_response.g.dart';

@JsonSerializable()
class TokenRefreshResponse {
  TokenRefreshResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenExpires,
  });

  final String accessToken;
  final String refreshToken;
  final int tokenExpires;

  factory TokenRefreshResponse.fromJson(Map<String, dynamic> json) =>
      _$TokenRefreshResponseFromJson(json);
}
