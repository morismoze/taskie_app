import 'package:flutter/material.dart';

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
    refreshUser = Command0(_refreshUser);
    _userNotifier.value = _userRepository.user;
  }

  final String _activeWorkspaceId;
  final UserRepository _userRepository;
  final WorkspaceTaskRepository _workspaceTaskRepository;
  final PreferencesRepository _preferencesRepository;

  late Command1<void, (ObjectiveFilter? filter, bool? forceFetch)> loadTasks;
  late Command0 refreshUser;

  String get activeWorkspaceId => _activeWorkspaceId;

  /// [appLocale] in [PreferencesRepository] is set up in AppStartup.
  Locale get appLocale => _preferencesRepository.appLocale!;

  final ValueNotifier<User?> _userNotifier = ValueNotifier(null);

  ValueNotifier<User?> get userNotifier => _userNotifier;

  bool get isFilterSearch => _workspaceTaskRepository.isFilterSearch;

  ObjectiveFilter get activeFilter => _workspaceTaskRepository.activeFilter;

  Paginable<WorkspaceTask>? get tasks {
    final tasks = _workspaceTaskRepository.tasks;

    if (tasks == null) {
      return null;
    }

    final clonedTasks = Paginable.clone(tasks);
    // Sort tasks so that tasks with `isNew` property set
    // to true are always at the top
    clonedTasks.items.sort((t1, t2) {
      // Checking `!t2.isNew` for stable sorting
      if (t1.isNew && !t2.isNew) {
        return -1;
      }

      if (t2.isNew && !t1.isNew) {
        // Checking `!t1.isNew` for stable sorting
        return 1;
      }

      // If both tasks are not new, keep the original ordering
      return 0;
    });

    return clonedTasks;
  }

  void _onTasksChanged() {
    // Forward the change notification from repository to the viewmodel
    notifyListeners();
  }

  void _onUserChanged() {
    _userNotifier.value = _userRepository.user;
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
        return const Result.ok(null);
      case Error():
        return result;
    }
  }

  Future<Result<void>> _refreshUser() async {
    final resultLoadUser = await _userRepository.loadUser(forceFetch: true);

    switch (resultLoadUser) {
      case Ok():
        return const Result.ok(null);
      case Error():
        return Result.error(resultLoadUser.error);
    }
  }

  @override
  void dispose() {
    _workspaceTaskRepository.removeListener(_onTasksChanged);
    _userRepository.removeListener(_onUserChanged);
    super.dispose();
  }
}
