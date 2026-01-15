// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserResponse _$UserResponseFromJson(Map<String, dynamic> json) => UserResponse(
  id: json['id'] as String,
  firstName: json['firstName'] as String,
  lastName: json['lastName'] as String,
  createdAt: json['createdAt'] as String,
  roles: (json['roles'] as List<dynamic>)
      .map((e) => RolePerWorkspace.fromJson(e as Map<String, dynamic>))
      .toList(),
  email: json['email'] as String?,
  profileImageUrl: json['profileImageUrl'] as String?,
);

RolePerWorkspace _$RolePerWorkspaceFromJson(Map<String, dynamic> json) =>
    RolePerWorkspace(
      workspaceId: json['workspaceId'] as String,
      role: $enumDecode(_$WorkspaceRoleEnumMap, json['role']),
    );

const _$WorkspaceRoleEnumMap = {
  WorkspaceRole.manager: 'MANAGER',
  WorkspaceRole.member: 'MEMBER',
};
