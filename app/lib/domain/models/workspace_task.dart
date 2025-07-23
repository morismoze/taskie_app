import '../../data/services/api/workspace/progress_status.dart';
import 'assignee.dart';

class WorkspaceTask {
  WorkspaceTask({
    required this.id,
    required this.title,
    required this.rewardPoints,
    required this.assignees,
    this.isNew = false,
    this.description,
  });

  final String id;
  final String title;
  final int rewardPoints;
  final List<TaskAssignee> assignees;

  /// Indicates if the task is newly created. Used
  /// for differentiating between newly created tasks
  /// and cached ones from origin.
  final bool isNew;
  final String? description;
}

class TaskAssignee extends Assignee {
  TaskAssignee({
    required super.id,
    required super.firstName,
    required super.lastName,
    super.profileImageUrl,
    required this.status,
  });

  final ProgressStatus status;
}
