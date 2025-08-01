// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workspace_task_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkspaceTaskResponse _$WorkspaceTaskResponseFromJson(
  Map<String, dynamic> json,
) => WorkspaceTaskResponse(
  id: json['id'] as String,
  title: json['title'] as String,
  rewardPoints: (json['rewardPoints'] as num).toInt(),
  assignees: (json['assignees'] as List<dynamic>)
      .map((e) => TaskAssigneeResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
  description: json['description'] as String?,
  dueDate: json['dueDate'] == null
      ? null
      : DateTime.parse(json['dueDate'] as String),
);

TaskAssigneeResponse _$TaskAssigneeResponseFromJson(
  Map<String, dynamic> json,
) => TaskAssigneeResponse(
  id: json['id'] as String,
  firstName: json['firstName'] as String,
  lastName: json['lastName'] as String,
  profileImageUrl: json['profileImageUrl'] as String?,
  status: $enumDecode(_$ProgressStatusEnumMap, json['status']),
);

const _$ProgressStatusEnumMap = {
  ProgressStatus.inProgress: 'IN_PROGRESS',
  ProgressStatus.completed: 'COMPLETED',
  ProgressStatus.completedAsStale: 'COMPLETED_AS_STALE',
  ProgressStatus.closed: 'CLOSED',
};
