import 'package:json_annotation/json_annotation.dart';

import '../../../../user/models/response/user_response.dart';
import '../../../created_by_response.dart';

part 'workspace_user_response.g.dart';

@JsonSerializable(createToJson: false)
class WorkspaceUserResponse {
  WorkspaceUserResponse({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.userId,
    required this.createdAt,
    required this.email,
    required this.profileImageUrl,
    required this.createdBy,
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
  final CreatedByResponse? createdBy;

  factory WorkspaceUserResponse.fromJson(Map<String, dynamic> json) =>
      _$WorkspaceUserResponseFromJson(json);
}
