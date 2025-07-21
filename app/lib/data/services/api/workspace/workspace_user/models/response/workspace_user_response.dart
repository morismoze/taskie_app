import 'package:json_annotation/json_annotation.dart';

import '../../../../user/models/response/user_response.dart';

part 'workspace_user_response.g.dart';

@JsonSerializable()
class WorkspaceUserResponse {
  WorkspaceUserResponse({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.userId,
    required this.createdAt,
    this.email,
    this.profileImageUrl,
    this.createdBy,
  });

  /// WorkspaceUser ID
  final String id;
  final String firstName;
  final String lastName;
  final WorkspaceRole role;
  final String userId;
  final DateTime createdAt;
  final String? email;
  final String? profileImageUrl;
  final WorkspaceUserCreatedByResponse? createdBy;

  factory WorkspaceUserResponse.fromJson(Map<String, dynamic> json) =>
      _$WorkspaceUserResponseFromJson(json);
}

@JsonSerializable()
class WorkspaceUserCreatedByResponse {
  WorkspaceUserCreatedByResponse({
    required this.firstName,
    required this.lastName,
    this.profileImageUrl,
  });

  final String firstName;
  final String lastName;
  final String? profileImageUrl;

  factory WorkspaceUserCreatedByResponse.fromJson(Map<String, dynamic> json) =>
      _$WorkspaceUserCreatedByResponseFromJson(json);
}
