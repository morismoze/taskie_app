import 'package:logging/logging.dart';

import '../../data/repositories/user/user_repository.dart';
import '../../data/repositories/workspace/leaderboard/workspace_leaderboard_repository.dart';
import '../../data/repositories/workspace/workspace/workspace_repository.dart';
import '../../data/repositories/workspace/workspace_goal/workspace_goal_repository.dart';
import '../../data/repositories/workspace/workspace_task/workspace_task_repository.dart';
import '../../data/repositories/workspace/workspace_user/workspace_user_repository.dart';
import '../../utils/command.dart';

class ActiveWorkspaceChangeUseCase {
  ActiveWorkspaceChangeUseCase({
    required WorkspaceRepository workspaceRepository,
    required WorkspaceUserRepository workspaceUserRepository,
    required WorkspaceTaskRepository workspaceTaskRepository,
    required WorkspaceLeaderboardRepository workspaceLeaderboardRepository,
    required WorkspaceGoalRepository workspaceGoalRepository,
    required UserRepository userRepository,
  }) : _workspaceRepository = workspaceRepository,
       _workspaceUserRepository = workspaceUserRepository,
       _workspaceTaskRepository = workspaceTaskRepository,
       _workspaceLeaderboardRepository = workspaceLeaderboardRepository,
       _workspaceGoalRepository = workspaceGoalRepository,
       _userRepository = userRepository;

  final WorkspaceRepository _workspaceRepository;
  final WorkspaceUserRepository _workspaceUserRepository;
  final WorkspaceTaskRepository _workspaceTaskRepository;
  final WorkspaceLeaderboardRepository _workspaceLeaderboardRepository;
  final WorkspaceGoalRepository _workspaceGoalRepository;
  final UserRepository _userRepository;

  final _log = Logger('ActiveWorkspaceChangeUseCase');

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
  /// 2. re-fetch user data
  ///
  /// 3. set the new active workspace ID.
  Future<Result<void>> handleWorkspaceChange(String workspaceId) async {
    _workspaceUserRepository.purgeWorkspaceUsersCache();
    _workspaceTaskRepository.purgeTasksCache();
    _workspaceLeaderboardRepository.purgeLeaderboardCache();
    _workspaceGoalRepository.purgeGoalsCache();

    final resultUser = await _userRepository.loadUser(forceFetch: true);

    switch (resultUser) {
      case Ok():
        break;
      case Error():
        _log.warning('Failed to refresh the user', resultUser.error);
        return Result.error(resultUser.error);
    }

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
