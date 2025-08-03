import '../../data/services/api/workspace/progress_status.dart';
import 'assignee.dart';

class WorkspaceTask {
  WorkspaceTask({
    required this.id,
    required this.title,
    required this.rewardPoints,
    required this.assignees,
    required this.createdAt,
    required this.description,
    required this.dueDate,
    this.isNew = false,
  });

  final String id;
  final String title;
  final int rewardPoints;
  final List<WorkspaceTaskAssignee> assignees;
  final DateTime createdAt;
  final String? description;
  final DateTime? dueDate;

  /// Indicates if the task is newly created. Used
  /// for differentiating between newly created tasks
  /// and cached ones from origin.
  final bool isNew;
}

class WorkspaceTaskAssignee extends Assignee {
  WorkspaceTaskAssignee({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.profileImageUrl,
    required this.status,
  });

  final ProgressStatus status;
}
