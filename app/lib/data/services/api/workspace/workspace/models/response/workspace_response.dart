import 'package:json_annotation/json_annotation.dart';

import '../../../created_by_response.dart';

part 'workspace_response.g.dart';

@JsonSerializable(createToJson: false)
class WorkspaceResponse {
  WorkspaceResponse({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.description,
    required this.pictureUrl,
    required this.createdBy,
  });

  final String id;
  final String name;
  final DateTime createdAt;
  final String? description;
  final String? pictureUrl;
  final CreatedByResponse? createdBy;

  factory WorkspaceResponse.fromJson(Map<String, dynamic> json) =>
      _$WorkspaceResponseFromJson(json);
}
