// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workspace_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkspaceResponse _$WorkspaceResponseFromJson(Map<String, dynamic> json) =>
    WorkspaceResponse(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      pictureUrl: json['pictureUrl'] as String?,
    );

Map<String, dynamic> _$WorkspaceResponseToJson(WorkspaceResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'pictureUrl': instance.pictureUrl,
    };
