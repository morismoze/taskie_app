import '../../data/repositories/user/user_repository.dart';
import '../../data/repositories/workspace/workspace/workspace_repository.dart';
import '../../utils/command.dart';
import 'purge_data_cache_use_case.dart';

class ActiveWorkspaceChangeUseCase {
  ActiveWorkspaceChangeUseCase({
    required WorkspaceRepository workspaceRepository,
    required UserRepository userRepository,
    required PurgeDataCacheUseCase purgeDataCacheUseCase,
  }) : _workspaceRepository = workspaceRepository,
       _userRepository = userRepository,
       _purgeDataCacheUseCase = purgeDataCacheUseCase;

  final WorkspaceRepository _workspaceRepository;
  final UserRepository _userRepository;
  final PurgeDataCacheUseCase _purgeDataCacheUseCase;

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
  /// 2. re-fetch user data - this is important as the user's role for that
  /// workspace could have been changed in the meantime
  ///
  /// 3. set the new active workspace ID.
  Future<Result<void>> handleWorkspaceChange(String workspaceId) async {
    final resultUser = await _userRepository.loadUser(forceFetch: true);

    switch (resultUser) {
      case Ok():
        break;
      case Error():
        return Result.error(resultUser.error);
    }

    final resultSetActive = await _workspaceRepository.setActiveWorkspaceId(
      workspaceId,
    );

    switch (resultSetActive) {
      case Ok():
        _purgeDataCacheUseCase.purgeDataCache();
        return const Result.ok(null);
      case Error():
        return Result.error(resultSetActive.error);
    }
  }
}
