import 'package:json_annotation/json_annotation.dart';

part 'create_workspace_invite_link_response.g.dart';

@JsonSerializable()
class CreateWorkspaceInviteLinkResponse {
  CreateWorkspaceInviteLinkResponse({required this.inviteLink});

  final String inviteLink;

  factory CreateWorkspaceInviteLinkResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$CreateWorkspaceInviteLinkResponseFromJson(json);
}
