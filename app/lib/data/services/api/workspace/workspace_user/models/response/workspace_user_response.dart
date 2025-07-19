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
    this.email,
    this.profileImageUrl,
  });

  /// WorkspaceUser ID
  final String id;
  final String firstName;
  final String lastName;
  final WorkspaceRole role;
  final String userId;
  final String? email;
  final String? profileImageUrl;

  factory WorkspaceUserResponse.fromJson(Map<String, dynamic> json) =>
      _$WorkspaceUserResponseFromJson(json);
}
