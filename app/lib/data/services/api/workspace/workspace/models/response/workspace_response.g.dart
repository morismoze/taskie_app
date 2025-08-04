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
          : WorkspaceCreatedByResponse.fromJson(
              json['createdBy'] as Map<String, dynamic>,
            ),
    );

WorkspaceCreatedByResponse _$WorkspaceCreatedByResponseFromJson(
  Map<String, dynamic> json,
) => WorkspaceCreatedByResponse(
  id: json['id'] as String,
  firstName: json['firstName'] as String,
  lastName: json['lastName'] as String,
  profileImageUrl: json['profileImageUrl'] as String?,
);
