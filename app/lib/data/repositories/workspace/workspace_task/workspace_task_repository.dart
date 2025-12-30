import 'package:flutter/material.dart';

import '../../../../domain/models/filter.dart';
import '../../../../domain/models/paginable.dart';
import '../../../../domain/models/workspace_task.dart';
import '../../../../utils/command.dart';
import '../../../services/api/value_patch.dart';
import '../../../services/api/workspace/progress_status.dart';

abstract class WorkspaceTaskRepository extends ChangeNotifier {
  bool get isFilterSearch;

  ObjectiveFilter get activeFilter;

  /// Assignees are sorted alphabetically by firstName and lastName
  Paginable<WorkspaceTask>? get tasks;

  Stream<Result<void>> loadTasks({
    required String workspaceId,
    bool forceFetch,
    ObjectiveFilter? filter,
  });

  Future<Result<void>> createTask(
    String workspaceId, {
    required String title,
    required List<String> assignees,
    required int rewardPoints,
    String? description,
    DateTime? dueDate,
  });

  Result<WorkspaceTask> loadWorkspaceTaskDetails({required String taskId});

  Future<Result<void>> updateTaskDetails(
    String workspaceId,
    String taskId, {
    ValuePatch<String>? title,
    ValuePatch<String?>? description,
    ValuePatch<int>? rewardPoints,
    ValuePatch<DateTime?>? dueDate,
  });

  Future<Result<void>> addTaskAssignee(
    String workspaceId,
    String taskId,
    List<String> assigneeIds,
  );

  Future<Result<void>> removeTaskAssignee(
    String workspaceId,
    String taskId,
    String assigneeId,
  );

  Future<Result<void>> updateTaskAssignments(
    String workspaceId,
    String taskId,
    List<(String assigneeId, ProgressStatus status)> assignments,
  );

  Future<Result<void>> closeTask({
    required String workspaceId,
    required String taskId,
  });

  Future<void> purgeTasksCache();
}
