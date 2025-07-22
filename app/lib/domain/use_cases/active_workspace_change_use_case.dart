import 'package:logging/logging.dart';

import '../../data/repositories/user/user_repository.dart';
import '../../data/repositories/workspace/workspace/workspace_repository.dart';
import '../../data/repositories/workspace/workspace_task/workspace_task_repository.dart';
import '../../data/repositories/workspace/workspace_user/workspace_user_repository.dart';
import '../../utils/command.dart';

class ActiveWorkspaceChangeUseCase {
  ActiveWorkspaceChangeUseCase({
    required WorkspaceRepository workspaceRepository,
    required UserRepository userRepository,
    required WorkspaceUserRepository workspaceUserRepository,
    required WorkspaceTaskRepository workspaceTaskRepository,
    // TODO: update when WorkspaceLeaderboardRepository is added: required WorkspaceLeaderboardRepository workspaceLeaderboardRepository,
    // TODO: update when WorkspaceGoalRepository is added: required WorkspaceGoalRepository workspaceGoalRepository,
  }) : _workspaceRepository = workspaceRepository,
       _userRepository = userRepository,
       _workspaceUserRepository = workspaceUserRepository,
       _workspaceTaskRepository = workspaceTaskRepository;

  final WorkspaceRepository _workspaceRepository;
  final UserRepository _userRepository;
  final WorkspaceUserRepository _workspaceUserRepository;
  final WorkspaceTaskRepository _workspaceTaskRepository;
  // final WorkspaceLeaderboardRepository _workspaceLeaderboardRepository;
  // final WorkspaceGoalRepository _workspaceGoalRepository;

  final _log = Logger('PurgeCachedDataUseCase');

  /// On every active workspace change:
  ///
  /// 1. when user sets the active workspace via the drawer
  ///
  /// 2. when user creates the new workspace and that new workspace
  /// should become the active one
  ///
  /// we need to:
  ///
  /// 1. clear the data cache which is relevant to the current active
  /// workspace. This data includes: workspace users, tasks, leaderboard, goals,
  ///
  /// 2. set the new active workspace ID.
  Future<Result<void>> handleWorkspaceChange(String workspaceId) async {
    _workspaceUserRepository.purgeWorkspaceUsersCache();
    _workspaceTaskRepository.purgeTasksCache();
    // _workspaceLeaderboardRepository.purgeLeaderboardCache();
    // _workspaceGoalRepository.purgeGoalsCache();

    final resultSetActive = await _workspaceRepository.setActiveWorkspaceId(
      workspaceId,
    );

    switch (resultSetActive) {
      case Ok():
        return const Result.ok(null);
      case Error():
        _log.warning(
          'Failed to set active workspace ID',
          resultSetActive.error,
        );
        return Result.error(resultSetActive.error);
    }
  }
}
