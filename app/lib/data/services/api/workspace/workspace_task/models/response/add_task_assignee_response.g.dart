// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_task_assignee_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddTaskAssigneeResponse _$AddTaskAssigneeResponseFromJson(
  Map<String, dynamic> json,
) => AddTaskAssigneeResponse(
  id: json['id'] as String,
  userId: json['userId'] as String,
  email: json['email'] as String?,
  firstName: json['firstName'] as String,
  lastName: json['lastName'] as String,
  profileImageUrl: json['profileImageUrl'] as String?,
  role: $enumDecode(_$WorkspaceRoleEnumMap, json['role']),
  createdBy: json['createdBy'] == null
      ? null
      : CreatedByResponse.fromJson(json['createdBy'] as Map<String, dynamic>),
  createdAt: DateTime.parse(json['createdAt'] as String),
  status: $enumDecode(_$ProgressStatusEnumMap, json['status']),
);

const _$WorkspaceRoleEnumMap = {
  WorkspaceRole.manager: 'MANAGER',
  WorkspaceRole.member: 'MEMBER',
};

const _$ProgressStatusEnumMap = {
  ProgressStatus.inProgress: 'IN_PROGRESS',
  ProgressStatus.completed: 'COMPLETED',
  ProgressStatus.completedAsStale: 'COMPLETED_AS_STALE',
  ProgressStatus.notCompleted: 'NOT_COMPLETED',
  ProgressStatus.closed: 'CLOSED',
};
