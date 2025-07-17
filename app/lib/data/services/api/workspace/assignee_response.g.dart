// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assignee_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AssigneeResponse _$AssigneeResponseFromJson(Map<String, dynamic> json) =>
    AssigneeResponse(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      status: $enumDecode(_$ProgressStatusEnumMap, json['status']),
      profileImageUrl: json['profileImageUrl'] as String?,
    );

Map<String, dynamic> _$AssigneeResponseToJson(AssigneeResponse instance) =>
    <String, dynamic>{
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
