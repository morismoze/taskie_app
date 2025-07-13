import 'package:json_annotation/json_annotation.dart';

import '../../../assignee_response.dart';
import '../../../progress_status.dart';

part 'workspace_goal_response.g.dart';

@JsonSerializable()
class WorkspaceGoalResponse {
  WorkspaceGoalResponse({
    required this.id,
    required this.title,
    required this.requiredPoints,
    required this.accumulatedPoints,
    required this.status,
    required this.assignee,
  });

  final String id;
  final String title;
  final int requiredPoints;
  final int accumulatedPoints;
  final AssigneeResponse assignee;
  final ProgressStatus status;

  factory WorkspaceGoalResponse.fromJson(Map<String, dynamic> json) =>
      _$WorkspaceGoalResponseFromJson(json);
}
