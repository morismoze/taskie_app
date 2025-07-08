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

Map<String, dynamic> _$UserResponseToJson(UserResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'createdAt': instance.createdAt,
      'roles': instance.roles,
      'email': instance.email,
      'profileImageUrl': instance.profileImageUrl,
    };

RolePerWorkspace _$RolePerWorkspaceFromJson(Map<String, dynamic> json) =>
    RolePerWorkspace(
      workspaceId: json['workspaceId'] as String,
      role: $enumDecode(_$WorkspaceRoleEnumMap, json['role']),
    );

Map<String, dynamic> _$RolePerWorkspaceToJson(RolePerWorkspace instance) =>
    <String, dynamic>{
      'workspaceId': instance.workspaceId,
      'role': _$WorkspaceRoleEnumMap[instance.role]!,
    };

const _$WorkspaceRoleEnumMap = {
  WorkspaceRole.manager: 'MANAGER',
  WorkspaceRole.member: 'MEMBER',
};
