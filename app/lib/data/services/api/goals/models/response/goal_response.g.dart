// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GoalResponse _$GoalResponseFromJson(Map<String, dynamic> json) => GoalResponse(
  id: json['id'] as String,
  title: json['title'] as String,
  requiredPoints: (json['requiredPoints'] as num).toInt(),
  accumulatedPoints: (json['accumulatedPoints'] as num).toInt(),
  status: $enumDecode(_$ProgressStatusEnumMap, json['status']),
  assignee: Assignee.fromJson(json['assignee'] as Map<String, dynamic>),
);

Map<String, dynamic> _$GoalResponseToJson(GoalResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'requiredPoints': instance.requiredPoints,
      'accumulatedPoints': instance.accumulatedPoints,
      'assignee': instance.assignee,
      'status': _$ProgressStatusEnumMap[instance.status]!,
    };

const _$ProgressStatusEnumMap = {
  ProgressStatus.inProgress: 'IN_PROGRESS',
  ProgressStatus.completed: 'COMPLETED',
  ProgressStatus.completedAsStale: 'COMPLETED_AS_STALE',
  ProgressStatus.closed: 'CLOSED',
};
