import 'package:json_annotation/json_annotation.dart';

part 'remove_task_assignee_request.g.dart';

@JsonSerializable(createFactory: false)
class RemoveTaskAssigneeRequest {
  RemoveTaskAssigneeRequest({required this.assigneeId});

  final String assigneeId;

  Map<String, dynamic> toJson() => _$RemoveTaskAssigneeRequestToJson(this);
}
