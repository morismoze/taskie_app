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
);

Map<String, dynamic> _$WorkspaceTaskResponseToJson(
  WorkspaceTaskResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'rewardPoints': instance.rewardPoints,
  'assignees': instance.assignees,
  'description': instance.description,
};

TaskAssigneeResponse _$TaskAssigneeResponseFromJson(
  Map<String, dynamic> json,
) => TaskAssigneeResponse(
  id: json['id'] as String,
  firstName: json['firstName'] as String,
  lastName: json['lastName'] as String,
  profileImageUrl: json['profileImageUrl'] as String?,
  status: $enumDecode(_$ProgressStatusEnumMap, json['status']),
);

Map<String, dynamic> _$TaskAssigneeResponseToJson(
  TaskAssigneeResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'profileImageUrl': instance.profileImageUrl,
  'status': _$ProgressStatusEnumMap[instance.status]!,
};

const _$ProgressStatusEnumMap = {
  ProgressStatus.inProgress: 'IN_PROGRESS',
  ProgressStatus.completed: 'COMPLETED',
  ProgressStatus.completedAsStale: 'COMPLETED_AS_STALE',
  ProgressStatus.closed: 'CLOSED',
};
