import 'assignee.dart';

class WorkspaceTask {
  WorkspaceTask({
    required this.id,
    required this.title,
    required this.rewardPoints,
    required this.assignees,
    this.isNew = false,
  });

  final String id;
  final String title;
  final int rewardPoints;
  final List<Assignee> assignees;

  /// Indicates if the task is newly created. Used
  /// for differentiating between newly created tasks
  /// and cached ones from origin.
  final bool isNew;
}
