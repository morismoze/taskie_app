import 'package:json_annotation/json_annotation.dart';

import '../../../assignee_response.dart';
import '../../../progress_status.dart';

part 'workspace_task_response.g.dart';

@JsonSerializable(createToJson: false)
class WorkspaceTaskResponse {
  WorkspaceTaskResponse({
    required this.id,
    required this.title,
    required this.rewardPoints,
    required this.assignees,
    required this.createdAt,
    required this.description,
    required this.dueDate,
  });

  final String id;
  final String title;
  final int rewardPoints;
  final List<TaskAssigneeResponse> assignees;
  final DateTime createdAt;
  final String? description;
  final DateTime? dueDate;

  factory WorkspaceTaskResponse.fromJson(Map<String, dynamic> json) =>
      _$WorkspaceTaskResponseFromJson(json);
}

@JsonSerializable(createToJson: false)
class TaskAssigneeResponse extends AssigneeResponse {
  TaskAssigneeResponse({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.profileImageUrl,
    required this.status,
  });

  final ProgressStatus status;

  factory TaskAssigneeResponse.fromJson(Map<String, dynamic> json) =>
      _$TaskAssigneeResponseFromJson(json);
}
