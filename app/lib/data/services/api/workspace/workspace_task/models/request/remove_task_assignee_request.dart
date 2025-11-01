import 'package:json_annotation/json_annotation.dart';

import 'add_task_assignee_request.dart';

@JsonSerializable(createFactory: false)
class RemoveTaskAssigneeRequest extends AddTaskAssigneeRequest {
  RemoveTaskAssigneeRequest({required super.assigneeId});
}
