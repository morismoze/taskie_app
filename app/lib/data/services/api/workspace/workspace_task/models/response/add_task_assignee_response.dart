import 'package:json_annotation/json_annotation.dart';

import '../../../../user/models/response/user_response.dart';
import '../../../created_by_response.dart';
import '../../../progress_status.dart';
import '../../../workspace_user/models/response/workspace_user_response.dart';

part 'add_task_assignee_response.g.dart';

@JsonSerializable(createToJson: false)
class AddTaskAssigneeResponse extends WorkspaceUserResponse {
  AddTaskAssigneeResponse({
    required super.id,
    required super.userId,
    required super.email,
    required super.firstName,
    required super.lastName,
    required super.profileImageUrl,
    required super.role,
    required super.createdBy,
    required super.createdAt,
    required this.status,
  });

  final ProgressStatus status;

  factory AddTaskAssigneeResponse.fromJson(Map<String, dynamic> json) =>
      _$AddTaskAssigneeResponseFromJson(json);
}
