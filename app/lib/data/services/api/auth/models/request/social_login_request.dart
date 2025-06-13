import 'package:json_annotation/json_annotation.dart';

part 'social_login_request.g.dart';

@JsonSerializable()
class SocialLoginRequest {
  SocialLoginRequest(this.idToken);

  final String idToken;

  Map<String, dynamic> toJson() => _$SocialLoginRequestToJson(this);
}
