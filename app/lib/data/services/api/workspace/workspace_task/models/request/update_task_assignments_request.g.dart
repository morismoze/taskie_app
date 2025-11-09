// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_task_assignments_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$UpdateTaskAssignmentsRequestToJson(
  UpdateTaskAssignmentsRequest instance,
) => <String, dynamic>{'assignments': instance.assignments};

Map<String, dynamic> _$AssignmentToJson(Assignment instance) =>
    <String, dynamic>{
      'assigneeId': instance.assigneeId,
      'status': _$ProgressStatusEnumMap[instance.status]!,
    };

const _$ProgressStatusEnumMap = {
  ProgressStatus.inProgress: 'IN_PROGRESS',
  ProgressStatus.completed: 'COMPLETED',
  ProgressStatus.completedAsStale: 'COMPLETED_AS_STALE',
  ProgressStatus.notCompleted: 'NOT_COMPLETED',
  ProgressStatus.closed: 'CLOSED',
};
