// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_workspace_invite_link_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateWorkspaceInviteLinkResponse _$CreateWorkspaceInviteLinkResponseFromJson(
  Map<String, dynamic> json,
) => CreateWorkspaceInviteLinkResponse(
  inviteLink: json['inviteLink'] as String,
  expiresAt: DateTime.parse(json['expiresAt'] as String),
);

Map<String, dynamic> _$CreateWorkspaceInviteLinkResponseToJson(
  CreateWorkspaceInviteLinkResponse instance,
) => <String, dynamic>{
  'inviteLink': instance.inviteLink,
  'expiresAt': instance.expiresAt.toIso8601String(),
};
