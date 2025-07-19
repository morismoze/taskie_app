import 'package:json_annotation/json_annotation.dart';

part 'create_workspace_invite_link_response.g.dart';

@JsonSerializable()
class CreateWorkspaceInviteLinkResponse {
  CreateWorkspaceInviteLinkResponse({
    required this.inviteLink,
    required this.expiresAt,
  });

  final String inviteLink;
  final DateTime expiresAt;

  factory CreateWorkspaceInviteLinkResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$CreateWorkspaceInviteLinkResponseFromJson(json);
}
