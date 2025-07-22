// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_workspace_user_details_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateWorkspaceUserDetailsRequest _$UpdateWorkspaceUserDetailsRequestFromJson(
  Map<String, dynamic> json,
) => UpdateWorkspaceUserDetailsRequest(
  firstName: json['firstName'] as String?,
  lastName: json['lastName'] as String?,
  role: json['role'] as String?,
);

Map<String, dynamic> _$UpdateWorkspaceUserDetailsRequestToJson(
  UpdateWorkspaceUserDetailsRequest instance,
) => <String, dynamic>{
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'role': instance.role,
};
