import 'package:json_annotation/json_annotation.dart';

part 'workspace_response.g.dart';

@JsonSerializable(createToJson: false)
class WorkspaceResponse {
  WorkspaceResponse({
    required this.id,
    required this.name,
    required this.createdAt,
    this.description,
    this.pictureUrl,
    this.createdBy,
  });

  final String id;
  final String name;
  final DateTime createdAt;
  final String? description;
  final String? pictureUrl;
  final WorkspaceCreatedByResponse? createdBy;

  factory WorkspaceResponse.fromJson(Map<String, dynamic> json) =>
      _$WorkspaceResponseFromJson(json);
}

@JsonSerializable(createToJson: false)
class WorkspaceCreatedByResponse {
  WorkspaceCreatedByResponse({
    required this.firstName,
    required this.lastName,
    this.profileImageUrl,
  });

  final String firstName;
  final String lastName;
  final String? profileImageUrl;

  factory WorkspaceCreatedByResponse.fromJson(Map<String, dynamic> json) =>
      _$WorkspaceCreatedByResponseFromJson(json);
}
