// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_workspace_invite_token_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateWorkspaceInviteTokenResponse _$CreateWorkspaceInviteTokenResponseFromJson(
  Map<String, dynamic> json,
) => CreateWorkspaceInviteTokenResponse(
  token: json['token'] as String,
  expiresAt: DateTime.parse(json['expiresAt'] as String),
);

Map<String, dynamic> _$CreateWorkspaceInviteTokenResponseToJson(
  CreateWorkspaceInviteTokenResponse instance,
) => <String, dynamic>{
  'token': instance.token,
  'expiresAt': instance.expiresAt.toIso8601String(),
};
