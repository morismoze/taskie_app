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

const _$ProgressStatusEnumMap = {
  ProgressStatus.inProgress: 'IN_PROGRESS',
  ProgressStatus.completed: 'COMPLETED',
  ProgressStatus.completedAsStale: 'COMPLETED_AS_STALE',
  ProgressStatus.notCompleted: 'NOT_COMPLETED',
  ProgressStatus.closed: 'CLOSED',
};
