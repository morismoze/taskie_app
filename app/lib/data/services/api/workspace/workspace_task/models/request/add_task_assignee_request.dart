import 'package:json_annotation/json_annotation.dart';

part 'add_task_assignee_request.g.dart';

@JsonSerializable(createFactory: false)
class AddTaskAssigneeRequest {
  AddTaskAssigneeRequest({required this.assigneeIds});

  final List<String> assigneeIds;

  Map<String, dynamic> toJson() => _$AddTaskAssigneeRequestToJson(this);
}
