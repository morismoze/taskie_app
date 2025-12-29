import '../../../../domain/models/workspace_leaderboard_user.dart';
import '../../../../utils/command.dart';
import '../../../services/api/workspace/workspace_leaderboard/models/response/workspace_leaderboard_user_response.dart';
import '../../../services/api/workspace/workspace_leaderboard/workspace_leaderboard_api_service.dart';
import '../../../services/local/logger_service.dart';
import 'workspace_leaderboard_repository.dart';

class WorkspaceLeaderboardRepositoryImpl
    extends WorkspaceLeaderboardRepository {
  WorkspaceLeaderboardRepositoryImpl({
    required WorkspaceLeaderboardApiService workspaceLeaderboardApiService,
    required LoggerService loggerService,
  }) : _workspaceLeaderboardApiService = workspaceLeaderboardApiService,
       _loggerService = loggerService;

  final WorkspaceLeaderboardApiService _workspaceLeaderboardApiService;
  final LoggerService _loggerService;

  List<WorkspaceLeaderboardUser>? _leaderboard;

  @override
  List<WorkspaceLeaderboardUser>? get leaderboard => _leaderboard;

  @override
  Future<Result<void>> loadLeaderboard({
    required String workspaceId,
    bool forceFetch = false,
  }) async {
    if (!forceFetch && _leaderboard != null) {
      return const Result.ok(null);
    }

    final result = await _workspaceLeaderboardApiService.loadLeaderboard(
      workspaceId,
    );

    switch (result) {
      case Ok<List<WorkspaceLeaderboardUserResponse>>():
        final leaderboard = result.value
            .map(
              (u) => WorkspaceLeaderboardUser(
                id: u.id,
                firstName: u.firstName,
                lastName: u.lastName,
                accumulatedPoints: u.accumulatedPoints,
                completedTasks: u.completedTasks,
                profileImageUrl: u.profileImageUrl,
              ),
            )
            .toList();
        _leaderboard = leaderboard;
        notifyListeners();

        return const Result.ok(null);
      case Error<List<WorkspaceLeaderboardUserResponse>>():
        _loggerService.log(
          LogLevel.warn,
          'workspaceLeaderboardApiService.loadLeaderboard failed',
          error: result.error,
          stackTrace: result.stackTrace,
        );
        return Result.error(result.error);
    }
  }

  @override
  void purgeLeaderboardCache() {
    _leaderboard = null;
  }
}
