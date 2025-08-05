import 'package:flutter/material.dart';

import '../../../../domain/models/filter.dart';
import '../../../../domain/models/paginable.dart';
import '../../../../domain/models/workspace_task.dart';
import '../../../../utils/command.dart';

abstract class WorkspaceTaskRepository extends ChangeNotifier {
  bool get isFilterSearch;

  ObjectiveFilter get activeFilter;

  Paginable<WorkspaceTask>? get tasks;

  Future<Result<void>> loadTasks({
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

  Result<WorkspaceTask> loadWorkspaceTaskDetails({
    required String workspaceId,
    required String taskId,
  });

  void purgeTasksCache();
}
