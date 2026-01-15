import 'package:json_annotation/json_annotation.dart';

import '../../../progress_status.dart';

part 'update_task_assignments_request.g.dart';

@JsonSerializable(createFactory: false)
class UpdateTaskAssignmentsRequest {
  UpdateTaskAssignmentsRequest({required this.assignments});

  final List<Assignment> assignments;

  Map<String, dynamic> toJson() => _$UpdateTaskAssignmentsRequestToJson(this);
}

@JsonSerializable(createFactory: false)
class Assignment {
  Assignment({required this.assigneeId, required this.status});

  final String assigneeId;
  final ProgressStatus status;

  Map<String, dynamic> toJson() => _$AssignmentToJson(this);
}
