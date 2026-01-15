import 'package:json_annotation/json_annotation.dart';

import '../../../user/models/response/user_response.dart';

part 'login_response.g.dart';

@JsonSerializable(createToJson: false)
class LoginResponse {
  LoginResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenExpires,
    required this.user,
  });

  final String accessToken;
  final String refreshToken;
  final int tokenExpires;
  final UserResponse user;

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
}
