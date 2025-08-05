import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

import '../../../data/repositories/workspace/workspace_task/workspace_task_repository.dart';
import '../../../domain/models/workspace_task.dart';
import '../../../utils/command.dart';

class TaskDetailsEditScreenViewModel extends ChangeNotifier {
  TaskDetailsEditScreenViewModel({
    required String workspaceId,
    required String taskId,
    required WorkspaceTaskRepository workspaceTaskRepository,
  }) : _activeWorkspaceId = workspaceId,
       _taskId = taskId,
       _workspaceTaskRepository = workspaceTaskRepository {
    _loadWorkspaceTaskDetails();
    editTaskDetails = Command1(_editTaskDetails);
  }

  final String _activeWorkspaceId;
  final String _taskId;
  final WorkspaceTaskRepository _workspaceTaskRepository;
  final _log = Logger('TaskDetailsEditScreenViewModel');

  late Command1<
    void,
    (String? title, String? description, int? rewardPoints, DateTime? dueDate)
  >
  editTaskDetails;

  String get activeWorkspaceId => _activeWorkspaceId;

  WorkspaceTask? _details;

  WorkspaceTask? get details => _details;

  Result<void> _loadWorkspaceTaskDetails() {
    final result = _workspaceTaskRepository.loadWorkspaceTaskDetails(
      workspaceId: _activeWorkspaceId,
      taskId: _taskId,
    );

    switch (result) {
      case Ok():
        _details = result.value;
        notifyListeners();
        return const Result.ok(null);
      case Error():
        _log.warning('Failed to load workspace task details', result.error);
        return result;
    }
  }

  Future<Result<void>> _editTaskDetails(
    (String? title, String? description, int? rewardPoints, DateTime? dueDate)
    details,
  ) async {
    final (title, description, rewardPoints, dueDate) = details;

    // Don't invoke API request if the data stayed the same
    if (title == _details!.title &&
        description == _details!.description &&
        rewardPoints == _details!.rewardPoints &&
        dueDate == _details!.dueDate) {
      return const Result.ok(null);
    }

    return const Result.ok(null);
  }
}
