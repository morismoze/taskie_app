// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workspace_user_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkspaceUserResponse _$WorkspaceUserResponseFromJson(
  Map<String, dynamic> json,
) => WorkspaceUserResponse(
  id: json['id'] as String,
  firstName: json['firstName'] as String,
  lastName: json['lastName'] as String,
  role: $enumDecode(_$WorkspaceRoleEnumMap, json['role']),
  userId: json['userId'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  email: json['email'] as String?,
  profileImageUrl: json['profileImageUrl'] as String?,
  createdBy: json['createdBy'] == null
      ? null
      : WorkspaceUserCreatedByResponse.fromJson(
          json['createdBy'] as Map<String, dynamic>,
        ),
);

const _$WorkspaceRoleEnumMap = {
  WorkspaceRole.manager: 'MANAGER',
  WorkspaceRole.member: 'MEMBER',
};

WorkspaceUserCreatedByResponse _$WorkspaceUserCreatedByResponseFromJson(
  Map<String, dynamic> json,
) => WorkspaceUserCreatedByResponse(
  id: json['id'] as String,
  firstName: json['firstName'] as String,
  lastName: json['lastName'] as String,
  profileImageUrl: json['profileImageUrl'] as String?,
);
