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
    this.dueDate,
  });

  final String id;
  final String title;
  final int rewardPoints;
  final List<WorkspaceTaskAssignee> assignees;

  /// Indicates if the task is newly created. Used
  /// for differentiating between newly created tasks
  /// and cached ones from origin.
  final bool isNew;
  final String? description;
  final DateTime? dueDate;
}

class WorkspaceTaskAssignee extends Assignee {
  WorkspaceTaskAssignee({
    required super.id,
    required super.firstName,
    required super.lastName,
    super.profileImageUrl,
    required this.status,
  });

  final ProgressStatus status;
}
