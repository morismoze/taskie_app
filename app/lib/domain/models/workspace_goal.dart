import '../../data/services/api/workspace/progress_status.dart';
import 'assignee.dart';
import 'created_by.dart';

class WorkspaceGoal {
  WorkspaceGoal({
    required this.id,
    required this.title,
    required this.requiredPoints,
    required this.accumulatedPoints,
    required this.assignee,
    required this.status,
    required this.createdAt,
    required this.createdBy,
    required this.description,
    this.isNew = false,
  });

  final String id;
  final String title;
  final int requiredPoints;
  final int accumulatedPoints;
  final Assignee assignee;
  final ProgressStatus status;
  final DateTime createdAt;
  final CreatedBy? createdBy;
  final String? description;

  /// Indicates if the goal is newly created. Used
  /// for differentiating between newly created goals
  /// and cached ones from origin.
  final bool isNew;

  WorkspaceGoal copyWith({ProgressStatus? status}) {
    return WorkspaceGoal(
      id: id,
      title: title,
      requiredPoints: requiredPoints,
      accumulatedPoints: accumulatedPoints,
      createdAt: createdAt,
      createdBy: createdBy,
      description: description,
      assignee: assignee,
      status: status ?? this.status,
      isNew: isNew,
    );
  }
}
