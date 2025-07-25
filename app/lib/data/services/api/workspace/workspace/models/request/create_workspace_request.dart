import 'package:json_annotation/json_annotation.dart';

part 'create_workspace_request.g.dart';

@JsonSerializable(createFactory: false)
class CreateWorkspaceRequest {
  CreateWorkspaceRequest({required this.name, this.description});

  final String name;
  final String? description;

  Map<String, dynamic> toJson() => _$CreateWorkspaceRequestToJson(this);
}
