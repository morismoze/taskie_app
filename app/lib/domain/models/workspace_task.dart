import 'assignee.dart';

class WorkspaceTask {
  WorkspaceTask({
    required this.id,
    required this.title,
    required this.rewardPoints,
    required this.assignees,
  });

  final String id;
  final String title;
  final int rewardPoints;
  final List<Assignee> assignees;
}
