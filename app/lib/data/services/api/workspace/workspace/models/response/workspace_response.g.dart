// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workspace_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkspaceResponse _$WorkspaceResponseFromJson(Map<String, dynamic> json) =>
    WorkspaceResponse(
      id: json['id'] as String,
      name: json['name'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      description: json['description'] as String?,
      pictureUrl: json['pictureUrl'] as String?,
      createdBy: json['createdBy'] == null
          ? null
          : CreatedByResponse.fromJson(
              json['createdBy'] as Map<String, dynamic>,
            ),
    );
