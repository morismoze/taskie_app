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
  profileImageUrl: json['profileImageUrl'] as String?,
);

Map<String, dynamic> _$WorkspaceUserResponseToJson(
  WorkspaceUserResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'role': _$WorkspaceRoleEnumMap[instance.role]!,
  'profileImageUrl': instance.profileImageUrl,
};

const _$WorkspaceRoleEnumMap = {
  WorkspaceRole.manager: 'MANAGER',
  WorkspaceRole.member: 'MEMBER',
};
