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
      .map((e) => AssigneeResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$WorkspaceTaskResponseToJson(
  WorkspaceTaskResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'rewardPoints': instance.rewardPoints,
  'assignees': instance.assignees,
};
