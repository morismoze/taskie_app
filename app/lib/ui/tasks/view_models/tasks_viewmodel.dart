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
    loadUser = Command0(_loadUser)..execute();
    loadTasks = Command1(_loadTasks)..execute(workspaceId);
  }

  final String _activeWorkspaceId;
  final UserRepository _userRepository;
  final WorkspaceTaskRepository _workspaceTaskRepository;
  final _log = Logger('TasksViewModel');

  late Command0 loadUser;
  late Command1<void, String> loadTasks;

  User? _user;

  User? get user => _user;

  List<WorkspaceTask>? _tasks;

  List<WorkspaceTask>? get tasks => _tasks;

  Future<Result<void>> _loadUser() async {
    final result = await _userRepository.getUser();

    switch (result) {
      case Ok():
        _user = result.value;
        notifyListeners();
      case Error():
        _log.warning('Failed to load user', result.error);
    }

    return result;
  }

  Future<Result<void>> _loadTasks(String workspaceId) async {
    final result = await _workspaceTaskRepository.getTasks(
      workspaceId: workspaceId,
      paginable: PaginableObjectivesRequestQueryParams(),
    );

    switch (result) {
      case Ok<List<WorkspaceTask>>():
        _tasks = result.value;
        notifyListeners();
      case Error<List<WorkspaceTask>>():
        _log.warning('Failed to load tasks', result.error);
    }

    return result;
  }
}
