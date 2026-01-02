import 'package:flutter/foundation.dart';

import '../../../data/repositories/workspace/workspace_task/workspace_task_repository.dart';
import '../../../data/services/api/value_patch.dart';
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
    _workspaceTaskRepository.addListener(_onWorkspaceTasksChanged);
    editTaskDetails = Command1(_editTaskDetails);
    closeTask = Command0(_closeTask);
  }

  final String _activeWorkspaceId;
  final String _taskId;
  final WorkspaceTaskRepository _workspaceTaskRepository;

  late Command0 closeTask;
  late Command1<
    void,
    (String? title, String? description, int? rewardPoints, DateTime? dueDate)
  >
  editTaskDetails;

  String get activeWorkspaceId => _activeWorkspaceId;

  WorkspaceTask? _details;

  WorkspaceTask? get details => _details;

  void _onWorkspaceTasksChanged() {
    _loadWorkspaceTaskDetails();
  }

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
        // This can happen when a task gets closed and removed from the cache
        // and the repository notifies listeners, in this case the task details
        // edit screen VM, which then tries to load the details again in a split
        // second before task is closed and user is navigated back to tasks
        // screen. Hence why we return positive result.
        return const Result.ok(null);
    }
  }

  Future<Result<void>> _editTaskDetails(
    (String? title, String? description, int? rewardPoints, DateTime? dueDate)
    details,
  ) async {
    final (title, description, rewardPoints, dueDate) = details;

    final hasTitleChanged = title != _details!.title;
    final hasDescriptionChanged = description != _details!.description;
    final hasRewardPointsChanged = rewardPoints != _details!.rewardPoints;
    final hasDueDateChanged = dueDate != _details!.dueDate;

    final result = await _workspaceTaskRepository.updateTaskDetails(
      _activeWorkspaceId,
      _details!.id,
      title: hasTitleChanged ? ValuePatch(title!) : null,
      description: hasDescriptionChanged ? ValuePatch(description) : null,
      rewardPoints: hasRewardPointsChanged ? ValuePatch(rewardPoints!) : null,
      dueDate: hasDueDateChanged ? ValuePatch(dueDate) : null,
    );

    switch (result) {
      case Ok():
        return const Result.ok(null);
      case Error():
        return result;
    }
  }

  Future<Result<void>> _closeTask() async {
    final result = await _workspaceTaskRepository.closeTask(
      workspaceId: activeWorkspaceId,
      taskId: _taskId,
    );

    switch (result) {
      case Ok():
        // Edge case: when the user closes all the tasks from
        // the current page, repository updates total and totalPages
        // and then we just re-fetch the current page again - the
        // thing is, current page will be updated in the repository
        // as said previously, and we will fetch that new page.
        // The actual UI page change is done in the ObjectivesListView and
        // here we only amend the repository level page value.
        final tasks = _workspaceTaskRepository.tasks;
        if (tasks == null || tasks.items.isEmpty) {
          _workspaceTaskRepository
              .loadTasks(workspaceId: _activeWorkspaceId, forceFetch: true)
              .listen((_) {});
        }
        return const Result.ok(null);
      case Error():
        return result;
    }
  }

  @override
  void dispose() {
    _workspaceTaskRepository.removeListener(_onWorkspaceTasksChanged);
    super.dispose();
  }
}
