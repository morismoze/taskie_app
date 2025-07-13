import 'package:json_annotation/json_annotation.dart';

import '../../../assignee_response.dart';

part 'workspace_task_response.g.dart';

@JsonSerializable()
class WorkspaceTaskResponse {
  WorkspaceTaskResponse({
    required this.id,
    required this.title,
    required this.rewardPoints,
    required this.assignees,
  });

  final String id;
  final String title;
  final int rewardPoints;
  final List<AssigneeResponse> assignees;

  factory WorkspaceTaskResponse.fromJson(Map<String, dynamic> json) =>
      _$WorkspaceTaskResponseFromJson(json);
}
