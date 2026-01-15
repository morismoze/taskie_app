import 'package:json_annotation/json_annotation.dart';

part 'user_response.g.dart';

@JsonSerializable(createToJson: false)
class UserResponse {
  UserResponse({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.createdAt,
    required this.roles,
    this.email,
    this.profileImageUrl,
  });

  final String id;
  final String firstName;
  final String lastName;
  final String createdAt;
  final List<RolePerWorkspace> roles;
  final String? email;
  final String? profileImageUrl;

  factory UserResponse.fromJson(Map<String, dynamic> json) =>
      _$UserResponseFromJson(json);
}

@JsonSerializable(createToJson: false)
class RolePerWorkspace {
  RolePerWorkspace({required this.workspaceId, required this.role});

  final String workspaceId;
  final WorkspaceRole role;

  Map<String, dynamic> toMap() => {
    'workspaceId': workspaceId,
    'role': role.value,
  };

  factory RolePerWorkspace.fromJson(Map<String, dynamic> json) =>
      _$RolePerWorkspaceFromJson(json);
}

enum WorkspaceRole {
  @JsonValue('MANAGER')
  manager('MANAGER'),

  @JsonValue('MEMBER')
  member('MEMBER');

  const WorkspaceRole(this.value);

  final String value;
}
