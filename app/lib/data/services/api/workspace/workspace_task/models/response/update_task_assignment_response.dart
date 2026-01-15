import 'package:json_annotation/json_annotation.dart';

import '../../../progress_status.dart';

part 'update_task_assignment_response.g.dart';

@JsonSerializable(createToJson: false)
class UpdateTaskAssignmentResponse {
  UpdateTaskAssignmentResponse({
    required this.assigneeId,
    required this.status,
  });

  final String assigneeId;
  final ProgressStatus status;

  factory UpdateTaskAssignmentResponse.fromJson(Map<String, dynamic> json) =>
      _$UpdateTaskAssignmentResponseFromJson(json);
}
