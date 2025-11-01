// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_task_assignment_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateTaskAssignmentResponse _$UpdateTaskAssignmentResponseFromJson(
  Map<String, dynamic> json,
) => UpdateTaskAssignmentResponse(
  assigneeId: json['assigneeId'] as String,
  status: $enumDecode(_$ProgressStatusEnumMap, json['status']),
);

const _$ProgressStatusEnumMap = {
  ProgressStatus.inProgress: 'IN_PROGRESS',
  ProgressStatus.completed: 'COMPLETED',
  ProgressStatus.completedAsStale: 'COMPLETED_AS_STALE',
  ProgressStatus.notCompleted: 'NOT_COMPLETED',
  ProgressStatus.closed: 'CLOSED',
};
