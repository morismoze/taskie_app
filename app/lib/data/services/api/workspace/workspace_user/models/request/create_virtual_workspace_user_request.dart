import 'package:json_annotation/json_annotation.dart';

part 'create_virtual_workspace_user_request.g.dart';

@JsonSerializable()
class CreateVirtualWorkspaceUserRequest {
  CreateVirtualWorkspaceUserRequest({
    required this.firstName,
    required this.lastName,
  });

  final String firstName;
  final String lastName;

  Map<String, dynamic> toJson() =>
      _$CreateVirtualWorkspaceUserRequestToJson(this);
}
