import '../../data/repositories/workspace/leaderboard/workspace_leaderboard_repository.dart';
import '../../data/repositories/workspace/workspace_goal/workspace_goal_repository.dart';
import '../../data/repositories/workspace/workspace_task/workspace_task_repository.dart';
import '../../data/repositories/workspace/workspace_user/workspace_user_repository.dart';

class PurgeDataCacheUseCase {
  PurgeDataCacheUseCase({
    required WorkspaceUserRepository workspaceUserRepository,
    required WorkspaceTaskRepository workspaceTaskRepository,
    required WorkspaceLeaderboardRepository workspaceLeaderboardRepository,
    required WorkspaceGoalRepository workspaceGoalRepository,
  }) : _workspaceUserRepository = workspaceUserRepository,
       _workspaceTaskRepository = workspaceTaskRepository,
       _workspaceLeaderboardRepository = workspaceLeaderboardRepository,
       _workspaceGoalRepository = workspaceGoalRepository;

  final WorkspaceUserRepository _workspaceUserRepository;
  final WorkspaceTaskRepository _workspaceTaskRepository;
  final WorkspaceLeaderboardRepository _workspaceLeaderboardRepository;
  final WorkspaceGoalRepository _workspaceGoalRepository;

  /// We purge data cache on multiple places, so this is a single source
  /// of truth method for future additional data.
  void purgeDataCache() {
    _workspaceUserRepository.purgeWorkspaceUsersCache();
    _workspaceTaskRepository.purgeTasksCache();
    _workspaceLeaderboardRepository.purgeLeaderboardCache();
    _workspaceGoalRepository.purgeGoalsCache();
  }
}
