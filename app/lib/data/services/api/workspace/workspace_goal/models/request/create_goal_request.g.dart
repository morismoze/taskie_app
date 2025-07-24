// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_goal_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateGoalRequest _$CreateGoalRequestFromJson(Map<String, dynamic> json) =>
    CreateGoalRequest(
      title: json['title'] as String,
      assignee: json['assignee'] as String,
      requiredPoints: (json['requiredPoints'] as num).toInt(),
      description: json['description'] as String?,
    );

Map<String, dynamic> _$CreateGoalRequestToJson(CreateGoalRequest instance) =>
    <String, dynamic>{
      'title': instance.title,
      'assignee': instance.assignee,
      'requiredPoints': instance.requiredPoints,
      'description': instance.description,
    };
