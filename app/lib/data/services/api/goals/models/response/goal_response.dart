import 'package:json_annotation/json_annotation.dart';

import '../../../task/models/response/task_response.dart';

part 'goal_response.g.dart';

@JsonSerializable()
class GoalResponse {
  GoalResponse({
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
  final Assignee assignee;
  final ProgressStatus status;

  factory GoalResponse.fromJson(Map<String, dynamic> json) =>
      _$GoalResponseFromJson(json);
}
