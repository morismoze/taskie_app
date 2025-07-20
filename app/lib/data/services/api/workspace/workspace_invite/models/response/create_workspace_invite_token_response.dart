import 'package:json_annotation/json_annotation.dart';

part 'create_workspace_invite_token_response.g.dart';

@JsonSerializable()
class CreateWorkspaceInviteTokenResponse {
  CreateWorkspaceInviteTokenResponse({
    required this.token,
    required this.expiresAt,
  });

  final String token;
  final DateTime expiresAt;

  factory CreateWorkspaceInviteTokenResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$CreateWorkspaceInviteTokenResponseFromJson(json);
}
