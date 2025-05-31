import 'package:json_annotation/json_annotation.dart';

part 'login_response.g.dart';

@JsonSerializable()
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
  final LoginResponseUser user;

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
}

@JsonSerializable()
class LoginResponseUser {
  LoginResponseUser({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.createdAt,
    this.email,
    this.profileImageUrl,
  });

  final String id;
  final String firstName;
  final String lastName;
  final String createdAt;
  final String? email;
  final String? profileImageUrl;

  factory LoginResponseUser.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseUserFromJson(json);
}
