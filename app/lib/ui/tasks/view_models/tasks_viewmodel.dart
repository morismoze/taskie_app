import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

import '../../../data/repositories/user/user_repository.dart';
import '../../../data/repositories/workspace/workspace_task/workspace_task_repository.dart';
import '../../../data/services/api/workspace/paginable_objectives.dart';
import '../../../domain/models/user.dart';
import '../../../domain/models/workspace_task.dart';
import '../../../utils/command.dart';

class TasksViewModel extends ChangeNotifier {
  TasksViewModel({
    required String workspaceId,
    required UserRepository userRepository,
    required WorkspaceTaskRepository workspaceTaskRepository,
  }) : _activeWorkspaceId = workspaceId,
       _userRepository = userRepository,
       _workspaceTaskRepository = workspaceTaskRepository {
    _workspaceTaskRepository.addListener(_onTasksChanged);
    _userRepository.addListener(_onUserChanged);
    loadTasks = Command1(_loadTasks)..execute(workspaceId);
  }

  final String _activeWorkspaceId;
  final UserRepository _userRepository;
  final WorkspaceTaskRepository _workspaceTaskRepository;
  final _log = Logger('TasksViewModel');

  late Command1<void, String> loadTasks;

  List<WorkspaceTask>? get tasks => _workspaceTaskRepository.tasks;

  User? get user => _userRepository.user;

  void _onTasksChanged() {
    // Forward the change notification from repository to the viewmodel
    notifyListeners();
  }

  void _onUserChanged() {
    // Forward the change notification from repository to the viewmodel
    notifyListeners();
  }

  Future<Result<void>> _loadTasks(String workspaceId) async {
    final result = await _workspaceTaskRepository.getTasks(
      workspaceId: workspaceId,
      paginable: PaginableObjectivesRequestQueryParams(),
    );

    switch (result) {
      case Ok():
        break;
      case Error():
        _log.warning('Failed to load tasks', result.error);
    }

    return result;
  }

  @override
  void dispose() {
    _workspaceTaskRepository.removeListener(_onTasksChanged);
    _userRepository.removeListener(_onUserChanged);
    super.dispose();
  }
}
