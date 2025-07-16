import 'package:logging/logging.dart';

import '../../data/repositories/user/user_repository.dart';
import '../../data/repositories/workspace/workspace/workspace_repository.dart';
import '../../data/repositories/workspace/workspace_task/workspace_task_repository.dart';
import '../../utils/command.dart';

class ActiveWorkspaceChangeUseCase {
  ActiveWorkspaceChangeUseCase({
    required WorkspaceRepository workspaceRepository,
    required UserRepository userRepository,
    required WorkspaceTaskRepository workspaceTaskRepository,
    // TODO: update when WorkspaceLeaderboardRepository is added: required WorkspaceLeaderboardRepository workspaceLeaderboardRepository,
    // TODO: update when WorkspaceGoalRepository is added: required WorkspaceGoalRepository workspaceGoalRepository,
  }) : _workspaceRepository = workspaceRepository,
       _userRepository = userRepository,
       _workspaceTaskRepository = workspaceTaskRepository;

  final WorkspaceRepository _workspaceRepository;
  final UserRepository _userRepository;
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
  /// 1. re-fetch user for the updated roles - this is done only on creating new
  /// workspace or leaving an existing one,
  ///
  /// 2. clear the data cache which is relevant to the current active
  /// workspace. This data includes: tasks, leaderboard, goals,
  ///
  /// 3. set the new active workspace ID.
  Future<Result<void>> handleWorkspaceChange(String workspaceId) async {
    final resultUser = await _userRepository.loadUser(forceFetch: true);

    switch (resultUser) {
      case Ok():
        break;
      case Error():
        _log.warning('Failed to refresh the user', resultUser.error);
        return Result.error(resultUser.error);
    }

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
