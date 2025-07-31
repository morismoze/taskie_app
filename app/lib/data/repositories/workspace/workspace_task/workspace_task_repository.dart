import 'package:flutter/material.dart';

import '../../../../domain/models/filter.dart';
import '../../../../domain/models/workspace_task.dart';
import '../../../../utils/command.dart';

/// This is a [ChangeNotifier] beacuse of 2 reasons:
///
/// 1. when creating new tasks, those tasks are pushed into the
/// current cached list of tasks,
///
/// 2. when user does pull-to-refresh, cached list of tasks
/// will be updated
abstract class WorkspaceTaskRepository extends ChangeNotifier {
  List<WorkspaceTask>? get tasks;

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

  void purgeTasksCache();
}
