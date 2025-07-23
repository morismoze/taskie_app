// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workspace_goal_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkspaceGoalResponse _$WorkspaceGoalResponseFromJson(
  Map<String, dynamic> json,
) => WorkspaceGoalResponse(
  id: json['id'] as String,
  title: json['title'] as String,
  requiredPoints: (json['requiredPoints'] as num).toInt(),
  accumulatedPoints: (json['accumulatedPoints'] as num).toInt(),
  status: $enumDecode(_$ProgressStatusEnumMap, json['status']),
  assignee: AssigneeResponse.fromJson(json['assignee'] as Map<String, dynamic>),
  description: json['description'] as String?,
);

Map<String, dynamic> _$WorkspaceGoalResponseToJson(
  WorkspaceGoalResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'requiredPoints': instance.requiredPoints,
  'accumulatedPoints': instance.accumulatedPoints,
  'assignee': instance.assignee,
  'status': _$ProgressStatusEnumMap[instance.status]!,
  'description': instance.description,
};

const _$ProgressStatusEnumMap = {
  ProgressStatus.inProgress: 'IN_PROGRESS',
  ProgressStatus.completed: 'COMPLETED',
  ProgressStatus.completedAsStale: 'COMPLETED_AS_STALE',
  ProgressStatus.closed: 'CLOSED',
};
