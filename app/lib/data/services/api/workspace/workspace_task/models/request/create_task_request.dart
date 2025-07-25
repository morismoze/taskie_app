import 'package:json_annotation/json_annotation.dart';

part 'create_task_request.g.dart';

@JsonSerializable(createFactory: false)
class CreateTaskRequest {
  CreateTaskRequest({
    required this.title,
    required this.assignees,
    required this.rewardPoints,
    this.description,
    this.dueDate,
  });

  final String title;
  final List<String> assignees;
  final int rewardPoints;
  final String? description;
  final String? dueDate; // ISO8601

  Map<String, dynamic> toJson() => _$CreateTaskRequestToJson(this);
}
