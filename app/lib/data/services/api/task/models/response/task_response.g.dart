// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskResponse _$TaskResponseFromJson(Map<String, dynamic> json) => TaskResponse(
  id: json['id'] as String,
  title: json['title'] as String,
  rewardPoints: (json['rewardPoints'] as num).toInt(),
  createdAt: json['createdAt'] as String,
  assignees: (json['assignees'] as List<dynamic>)
      .map((e) => Assignee.fromJson(e as Map<String, dynamic>))
      .toList(),
  email: json['email'] as String?,
  profileImageUrl: json['profileImageUrl'] as String?,
);

Map<String, dynamic> _$TaskResponseToJson(TaskResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'rewardPoints': instance.rewardPoints,
      'createdAt': instance.createdAt,
      'assignees': instance.assignees,
      'email': instance.email,
      'profileImageUrl': instance.profileImageUrl,
    };

Assignee _$AssigneeFromJson(Map<String, dynamic> json) => Assignee(
  id: json['id'] as String,
  firstName: json['firstName'] as String,
  lastName: json['lastName'] as String,
  status: $enumDecode(_$ProgressStatusEnumMap, json['status']),
  profileImageUrl: json['profileImageUrl'] as String?,
);

Map<String, dynamic> _$AssigneeToJson(Assignee instance) => <String, dynamic>{
  'id': instance.id,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'status': _$ProgressStatusEnumMap[instance.status]!,
  'profileImageUrl': instance.profileImageUrl,
};

const _$ProgressStatusEnumMap = {
  ProgressStatus.inProgress: 'IN_PROGRESS',
  ProgressStatus.completed: 'COMPLETED',
  ProgressStatus.completedAsStale: 'COMPLETED_AS_STALE',
  ProgressStatus.closed: 'CLOSED',
};
