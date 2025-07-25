import 'package:json_annotation/json_annotation.dart';

part 'update_workspace_details_request.g.dart';

@JsonSerializable(createFactory: false)
class UpdateWorkspaceDetailsRequest {
  UpdateWorkspaceDetailsRequest({this.name, this.description});

  final String? name;
  final String? description;

  Map<String, dynamic> toJson() => _$UpdateWorkspaceDetailsRequestToJson(this);
}
