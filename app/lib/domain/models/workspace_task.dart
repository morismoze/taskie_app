import '../../data/services/api/workspace/progress_status.dart';
import 'assignee.dart';
import 'created_by.dart';

class WorkspaceTask {
  WorkspaceTask({
    required this.id,
    required this.title,
    required this.rewardPoints,
    required this.assignees,
    required this.createdAt,
    required this.createdBy,
    required this.description,
    required this.dueDate,
    this.isNew = false,
  });

  final String id;
  final String title;
  final int rewardPoints;
  final List<WorkspaceTaskAssignee> assignees;
  final DateTime createdAt;
  final CreatedBy? createdBy;
  final String? description;
  final DateTime? dueDate;

  /// Indicates if the task is newly created. Used
  /// for differentiating between newly created tasks
  /// and cached ones from origin.
  final bool isNew;

  WorkspaceTask copyWith({List<WorkspaceTaskAssignee>? assignees}) {
    return WorkspaceTask(
      id: id,
      title: title,
      rewardPoints: rewardPoints,
      assignees: assignees ?? this.assignees,
      createdAt: createdAt,
      createdBy: createdBy,
      description: description,
      dueDate: dueDate,
      isNew: isNew,
    );
  }
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

  WorkspaceTaskAssignee copyWith({ProgressStatus? status}) {
    return WorkspaceTaskAssignee(
      id: id,
      firstName: firstName,
      lastName: lastName,
      profileImageUrl: profileImageUrl,
      status: status ?? this.status,
    );
  }
}
