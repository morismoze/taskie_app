import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import '../../../data/repositories/preferences/preferences_repository.dart';
import '../../../data/repositories/user/user_repository.dart';
import '../../../data/repositories/workspace/workspace_task/workspace_task_repository.dart';
import '../../../domain/models/filter.dart';
import '../../../domain/models/paginable.dart';
import '../../../domain/models/user.dart';
import '../../../domain/models/workspace_task.dart';
import '../../../utils/command.dart';

class TasksScreenViewModel extends ChangeNotifier {
  TasksScreenViewModel({
    required String workspaceId,
    required UserRepository userRepository,
    required WorkspaceTaskRepository workspaceTaskRepository,
    required PreferencesRepository preferencesRepository,
  }) : _activeWorkspaceId = workspaceId,
       _userRepository = userRepository,
       _workspaceTaskRepository = workspaceTaskRepository,
       _preferencesRepository = preferencesRepository {
    _workspaceTaskRepository.addListener(_onTasksChanged);
    _userRepository.addListener(_onUserChanged);
    // Repository defines default values for ObjectiveFilter, so we use null here for it
    loadTasks = Command1(_loadTasks)..execute((null, null));
  }

  final String _activeWorkspaceId;
  final UserRepository _userRepository;
  final WorkspaceTaskRepository _workspaceTaskRepository;
  final PreferencesRepository _preferencesRepository;
  final _log = Logger('TasksScreenViewModel');

  late Command1<void, (ObjectiveFilter? filter, bool? forceFetch)> loadTasks;

  String get activeWorkspaceId => _activeWorkspaceId;

  bool get isInitialLoad => _workspaceTaskRepository.isInitialLoad;

  ObjectiveFilter get activeFilter => _workspaceTaskRepository.activeFilter;

  Paginable<WorkspaceTask>? get tasks => _workspaceTaskRepository.tasks;

  /// [appLocale] in [PreferencesRepository] is set up in AppStartup.
  Locale get appLocale => _preferencesRepository.appLocale!;

  User? get user => _userRepository.user;

  void _onTasksChanged() {
    // Forward the change notification from repository to the viewmodel
    notifyListeners();
  }

  void _onUserChanged() {
    // Forward the change notification from repository to the viewmodel
    notifyListeners();
  }

  Future<Result<void>> _loadTasks(
    (ObjectiveFilter? filter, bool? forceFetch) details,
  ) async {
    final (filter, forceFetch) = details;
    final result = await _workspaceTaskRepository.loadTasks(
      workspaceId: _activeWorkspaceId,
      filter: filter,
      forceFetch: forceFetch ?? false,
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
