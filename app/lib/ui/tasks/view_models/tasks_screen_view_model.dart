import 'package:flutter/material.dart';

import '../../../data/repositories/client_info/client_info_repository.dart';
import '../../../data/repositories/preferences/preferences_repository.dart';
import '../../../data/repositories/remote_config/remote_config_repository.dart';
import '../../../data/repositories/user/user_repository.dart';
import '../../../data/repositories/workspace/workspace_task/workspace_task_repository.dart';
import '../../../domain/models/filter.dart';
import '../../../domain/models/paginable.dart';
import '../../../domain/models/remote_config.dart';
import '../../../domain/models/user.dart';
import '../../../domain/models/workspace_task.dart';
import '../../../utils/command.dart';

class TasksScreenViewModel extends ChangeNotifier {
  TasksScreenViewModel({
    required String workspaceId,
    required UserRepository userRepository,
    required WorkspaceTaskRepository workspaceTaskRepository,
    required PreferencesRepository preferencesRepository,
    required RemoteConfigRepository remoteConfigRepository,
    required ClientInfoRepository clientInfoRepository,
  }) : _activeWorkspaceId = workspaceId,
       _userRepository = userRepository,
       _workspaceTaskRepository = workspaceTaskRepository,
       _preferencesRepository = preferencesRepository,
       _remoteConfigRepository = remoteConfigRepository,
       _clientInfoRepository = clientInfoRepository {
    _workspaceTaskRepository.addListener(_onTasksChanged);
    _userRepository.addListener(_onUserChanged);
    // Repository defines default values for ObjectiveFilter, so we use null here for it
    loadTasks = Command1(_loadTasks)..execute((null, null));
    refreshUser = Command0(_refreshUser);
    checkLatestAppUpdate = Command0(_checkLatestAppUpdate)..execute();
    _userNotifier.value = _userRepository.user;
  }

  final String _activeWorkspaceId;
  final UserRepository _userRepository;
  final WorkspaceTaskRepository _workspaceTaskRepository;
  final PreferencesRepository _preferencesRepository;
  final RemoteConfigRepository _remoteConfigRepository;
  final ClientInfoRepository _clientInfoRepository;

  late Command1<void, (ObjectiveFilter? filter, bool? forceFetch)> loadTasks;
  late Command0 refreshUser;
  late Command0 checkLatestAppUpdate;

  String get activeWorkspaceId => _activeWorkspaceId;

  /// [appLocale] in [PreferencesRepository] is set up in AppStartup.
  Locale get appLocale => _preferencesRepository.appLocale!;

  final ValueNotifier<User?> _userNotifier = ValueNotifier(null);

  ValueNotifier<User?> get userNotifier => _userNotifier;

  bool get isFilterSearch => _workspaceTaskRepository.isFilterSearch;

  ObjectiveFilter get activeFilter => _workspaceTaskRepository.activeFilter;

  bool _isForceFetching = false;

  bool get isForceFetching => _isForceFetching;

  String _latestAppVersion = '';

  String get latestVersion => _latestAppVersion;

  bool _shouldShowAppUpdate = false;

  bool get shouldShowAppUpdate => _shouldShowAppUpdate;

  String get playStoreUrl =>
      'https://play.google.com/store/apps/details?id=${_clientInfoRepository.clientInfo.appId}';

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
    // Forward the change notification from repository to the view
    notifyListeners();
  }

  void _onUserChanged() {
    _userNotifier.value = _userRepository.user;
  }

  Future<Result<void>> _loadTasks(
    (ObjectiveFilter? filter, bool? forceFetch) details,
  ) async {
    final (filter, forceFetch) = details;
    _isForceFetching = forceFetch ?? false;
    final result = await _workspaceTaskRepository
        .loadTasks(
          workspaceId: _activeWorkspaceId,
          filter: filter,
          forceFetch: _isForceFetching,
        )
        .last;
    _isForceFetching = false;

    switch (result) {
      case Ok():
        return const Result.ok(null);
      case Error():
        return result;
    }
  }

  Future<Result<void>> _refreshUser() async {
    final resultLoadUser = await _userRepository
        .loadUser(forceFetch: true)
        .last;

    switch (resultLoadUser) {
      case Ok():
        return const Result.ok(null);
      case Error():
        return Result.error(resultLoadUser.error);
    }
  }

  Future<Result<void>> _checkLatestAppUpdate() async {
    final resultAppConfig = await _remoteConfigRepository.appConfig;

    switch (resultAppConfig) {
      case Ok<RemoteConfig>():
        final vLatest = resultAppConfig.value.appLatestVersion;
        final vInstalled = _clientInfoRepository.clientInfo.appVersion;

        if (_checkIsLatestNewVersion(vInstalled, vLatest)) {
          _shouldShowAppUpdate = true;
          _latestAppVersion = vLatest;
          notifyListeners();
        }
        return const Result.ok(null);
      case Error<RemoteConfig>():
        return Result.error(resultAppConfig.error, resultAppConfig.stackTrace);
    }
  }

  void setAppUpdateVisibility(bool visible) {
    if (_shouldShowAppUpdate == visible) {
      return;
    }

    _shouldShowAppUpdate = visible;
    if (_shouldShowAppUpdate) {
      notifyListeners();
    }
  }

  bool _checkIsLatestNewVersion(String installed, String latest) {
    if (latest.isEmpty) {
      return false;
    }

    final v1 = installed.split('.').map(int.parse).toList();
    final v2 = latest.split('.').map(int.parse).toList();

    for (var i = 0; i < v2.length; i++) {
      if (i >= v1.length) return true;
      if (v2[i] > v1[i]) return true;
      if (v2[i] < v1[i]) return false;
    }
    return false;
  }

  @override
  void dispose() {
    _workspaceTaskRepository.removeListener(_onTasksChanged);
    _userRepository.removeListener(_onUserChanged);
    _userNotifier.dispose();
    super.dispose();
  }
}
