import '../../data/services/api/workspace/progress_status.dart';
import 'assignee.dart';

class WorkspaceGoal {
  WorkspaceGoal({
    required this.id,
    required this.title,
    required this.requiredPoints,
    required this.assignee,
    required this.status,
    this.isNew = false,
    this.description,
  });

  final String id;
  final String title;
  final int requiredPoints;
  final Assignee assignee;
  final ProgressStatus status;

  /// Indicates if the goal is newly created. Used
  /// for differentiating between newly created goals
  /// and cached ones from origin.
  final bool isNew;
  final String? description;
}
