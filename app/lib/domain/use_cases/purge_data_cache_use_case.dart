import '../../data/repositories/workspace/leaderboard/workspace_leaderboard_repository.dart';
import '../../data/repositories/workspace/workspace_goal/workspace_goal_repository.dart';
import '../../data/repositories/workspace/workspace_invite/workspace_invite_repository.dart';
import '../../data/repositories/workspace/workspace_task/workspace_task_repository.dart';
import '../../data/repositories/workspace/workspace_user/workspace_user_repository.dart';

class PurgeDataCacheUseCase {
  PurgeDataCacheUseCase({
    required WorkspaceUserRepository workspaceUserRepository,
    required WorkspaceTaskRepository workspaceTaskRepository,
    required WorkspaceLeaderboardRepository workspaceLeaderboardRepository,
    required WorkspaceGoalRepository workspaceGoalRepository,
    required WorkspaceInviteRepository workspaceInviteRepository,
  }) : _workspaceUserRepository = workspaceUserRepository,
       _workspaceTaskRepository = workspaceTaskRepository,
       _workspaceLeaderboardRepository = workspaceLeaderboardRepository,
       _workspaceGoalRepository = workspaceGoalRepository,
       _workspaceInviteRepository = workspaceInviteRepository;

  final WorkspaceUserRepository _workspaceUserRepository;
  final WorkspaceTaskRepository _workspaceTaskRepository;
  final WorkspaceLeaderboardRepository _workspaceLeaderboardRepository;
  final WorkspaceGoalRepository _workspaceGoalRepository;
  final WorkspaceInviteRepository _workspaceInviteRepository;

  /// We purge data cache on multiple places, so this is a single source
  /// of truth method for future additional data.
  Future<void> purgeDataCache() async {
    await _workspaceUserRepository.purgeWorkspaceUsersCache();
    await _workspaceTaskRepository.purgeTasksCache();
    await _workspaceLeaderboardRepository.purgeLeaderboardCache();
    await _workspaceGoalRepository.purgeGoalsCache();
    _workspaceInviteRepository.purgeWorkspaceInvites();
  }
}
