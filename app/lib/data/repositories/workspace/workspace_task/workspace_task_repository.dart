import 'package:flutter/material.dart';

import '../../../../domain/models/workspace_task.dart';
import '../../../../utils/command.dart';
import '../../../services/api/workspace/paginable_objectives.dart';

/// This is a [ChangeNotifier] beacuse of 2 reasons:
///
/// 1. when creating new tasks, those tasks are pushed into the
/// current cached list of tasks,
///
/// 2. when user does pull-to-refresh, cached list of tasks
/// will be updated
abstract class WorkspaceTaskRepository extends ChangeNotifier {
  List<WorkspaceTask>? get tasks;

  Future<Result<void>> getTasks({
    required String workspaceId,
    required PaginableObjectivesRequestQueryParams paginable,
    bool forceFetch,
  });

  Future<Result<void>> createTask(
    String workspaceId, {
    required String title,
    required List<String> assignees,
    required rewardPoints,
    String? description,
    String? dueData,
  });

  void purgeTasksCache();
}
