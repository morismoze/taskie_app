import 'package:flutter/foundation.dart';

import '../../../data/repositories/workspace/workspace_task/workspace_task_repository.dart';
import '../../../domain/models/workspace_task.dart';
import '../../../utils/command.dart';

class TaskDetailsScreenViewModel extends ChangeNotifier {
  TaskDetailsScreenViewModel({
    required String workspaceId,
    required String taskId,
    required WorkspaceTaskRepository workspaceTaskRepository,
  }) : _activeWorkspaceId = workspaceId,
       _taskId = taskId,
       _workspaceTaskRepository = workspaceTaskRepository {
    _loadWorkspaceTaskDetails();
  }

  final String _activeWorkspaceId;
  final String _taskId;
  final WorkspaceTaskRepository _workspaceTaskRepository;

  String get activeWorkspaceId => _activeWorkspaceId;

  WorkspaceTask? _details;

  WorkspaceTask? get details => _details;

  Result<void> _loadWorkspaceTaskDetails() {
    final result = _workspaceTaskRepository.loadWorkspaceTaskDetails(
      taskId: _taskId,
    );

    switch (result) {
      case Ok():
        _details = result.value;
        notifyListeners();
        return const Result.ok(null);
      case Error():
        return result;
    }
  }
}
