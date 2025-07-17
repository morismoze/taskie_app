import 'package:json_annotation/json_annotation.dart';

part 'workspace_response.g.dart';

@JsonSerializable()
class WorkspaceResponse {
  WorkspaceResponse({
    required this.id,
    required this.name,
    this.description,
    this.pictureUrl,
  });

  final String id;
  final String name;
  final String? description;
  final String? pictureUrl;

  factory WorkspaceResponse.fromJson(Map<String, dynamic> json) =>
      _$WorkspaceResponseFromJson(json);
}
