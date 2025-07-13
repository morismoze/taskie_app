import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

import '../../../../data/repositories/workspace/workspace/workspace_repository.dart';
import '../../../../data/repositories/workspace/workspace_task/workspace_task_repository.dart';
import '../../../../domain/models/workspace.dart';
import '../../../../domain/use_cases/refresh_token_use_case.dart';
import '../../../../utils/command.dart';

class AppDrawerViewModel extends ChangeNotifier {
  AppDrawerViewModel({
    required String workspaceId,
    required WorkspaceRepository workspaceRepository,
    required WorkspaceTaskRepository workspaceTaskRepository,
    required RefreshTokenUseCase refreshTokenUseCase,
    // TODO: update when WorkspaceLeaderboardRepository is added: required WorkspaceLeaderboardRepository workspaceLeaderboardRepository,
    // TODO: update when WorkspaceGoalRepository is added: required WorkspaceGoalRepository workspaceGoalRepository,
  }) : _activeWorkspaceId = workspaceId,
       _workspaceRepository = workspaceRepository,
       _workspaceTaskRepository = workspaceTaskRepository,
       _refreshTokenUseCase = refreshTokenUseCase {
    loadWorkspaces = Command0(_loadWorkspaces);
    leaveWorkspace = Command1(_leaveWorkspace);
    changeActiveWorkspace = Command1(_changeActiveWorkspace);
  }

  final String _activeWorkspaceId;
  final WorkspaceRepository _workspaceRepository;
  final WorkspaceTaskRepository _workspaceTaskRepository;
  final RefreshTokenUseCase _refreshTokenUseCase;
  final _log = Logger('AppDrawerViewModel');

  late Command0 loadWorkspaces;
  late Command1<void, String> leaveWorkspace;
  late Command1<String, String> changeActiveWorkspace;

  String get activeWorkspaceId => _activeWorkspaceId;

  List<Workspace> _workspaces = [];

  List<Workspace> get workspaces => _workspaces;

  String? _inviteLink;

  String? get inviteLink => _inviteLink;

  Future<Result<void>> _loadWorkspaces() async {
    final result = await _workspaceRepository.getWorkspaces();

    switch (result) {
      case Ok():
        _workspaces = result.value;
        notifyListeners();
      case Error():
        _log.warning('Failed to load workspaces', result.error);
    }

    return result;
  }

  Future<Result<String>> _changeActiveWorkspace(String workspaceId) async {
    // When a workspace is selected as active we need to:
    // 1. clear the cache for all contexts which depend on currently selected workspace.
    // This includes resetting tasks/leaderboard/goals caches.
    // 2. set the selected workspace as active, so it is saved in storage

    _workspaceTaskRepository.purgeTasksCache();
    // _workspaceLeaderboardRepository.purgeLeaderboardCache();
    // _workspaceGoalRepository.purgeGoalsCache();

    final result = await _workspaceRepository.setActiveWorkspaceId(workspaceId);

    switch (result) {
      case Ok():
        return Result.ok(workspaceId);
      case Error():
        _log.warning('Failed to set active workspace ID', result.error);
        return Result.error(result.error);
    }
  }

  Future<Result<void>> _leaveWorkspace(String workspaceId) async {
    final resultLeave = await _workspaceRepository.leaveWorkspace(
      workspaceId: workspaceId,
    );

    switch (resultLeave) {
      case Ok():
        break;
      case Error():
        _log.warning('Failed to leave the workspace', resultLeave.error);
        return Result.error(resultLeave.error);
    }

    // We need to refresh the access token since we keep list of roles with
    // corresponding workspaces inside the access token.
    final resultRefresh = await _refreshTokenUseCase.refreshAcessToken();

    switch (resultRefresh) {
      case Ok():
        break;
      case Error():
        _log.warning('Failed to refresh token', resultRefresh.error);
        return Result.error(resultRefresh.error);
    }

    // We need to load workspaces again - this will load from repository cache, which was updated with the
    // given workspace by removing it from that cache list in WorkspaceRepository.leaveWorkspace function.
    return await _loadWorkspaces();
  }
}
