import 'package:json_annotation/json_annotation.dart';

part 'create_goal_request.g.dart';

@JsonSerializable()
class CreateGoalRequest {
  CreateGoalRequest({
    required this.title,
    required this.assignee,
    required this.requiredPoints,
    this.description,
  });

  final String title;
  final String assignee;
  final int requiredPoints;
  final String? description;

  Map<String, dynamic> toJson() => _$CreateGoalRequestToJson(this);
}
