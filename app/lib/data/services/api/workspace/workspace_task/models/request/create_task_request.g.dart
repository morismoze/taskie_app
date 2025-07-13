// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_task_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateTaskRequest _$CreateTaskRequestFromJson(Map<String, dynamic> json) =>
    CreateTaskRequest(
      title: json['title'] as String,
      assignees: (json['assignees'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      rewardPoints: (json['rewardPoints'] as num).toInt(),
      description: json['description'] as String?,
      dueDate: json['dueDate'] as String?,
    );

Map<String, dynamic> _$CreateTaskRequestToJson(CreateTaskRequest instance) =>
    <String, dynamic>{
      'title': instance.title,
      'assignees': instance.assignees,
      'rewardPoints': instance.rewardPoints,
      'description': instance.description,
      'dueDate': instance.dueDate,
    };
