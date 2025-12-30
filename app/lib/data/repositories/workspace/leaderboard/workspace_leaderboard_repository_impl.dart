import '../../../../domain/models/workspace_leaderboard_user.dart';
import '../../../../utils/command.dart';
import '../../../services/api/workspace/workspace_leaderboard/models/response/workspace_leaderboard_user_response.dart';
import '../../../services/api/workspace/workspace_leaderboard/workspace_leaderboard_api_service.dart';
import '../../../services/local/database_service.dart';
import '../../../services/local/logger_service.dart';
import 'workspace_leaderboard_repository.dart';

class WorkspaceLeaderboardRepositoryImpl
    extends WorkspaceLeaderboardRepository {
  WorkspaceLeaderboardRepositoryImpl({
    required WorkspaceLeaderboardApiService workspaceLeaderboardApiService,
    required DatabaseService databaseService,
    required LoggerService loggerService,
  }) : _workspaceLeaderboardApiService = workspaceLeaderboardApiService,
       _databaseService = databaseService,
       _loggerService = loggerService;

  final WorkspaceLeaderboardApiService _workspaceLeaderboardApiService;
  final DatabaseService _databaseService;
  final LoggerService _loggerService;

  List<WorkspaceLeaderboardUser>? _cachedLeaderboard;

  @override
  List<WorkspaceLeaderboardUser>? get leaderboard => _cachedLeaderboard;

  @override
  Stream<Result<void>> loadLeaderboard({
    required String workspaceId,
    bool forceFetch = false,
  }) async* {
    // Read from in-memory cache
    if (!forceFetch && _cachedLeaderboard != null) {
      yield const Result.ok(null);
    }

    // Read from DB cache
    if (!forceFetch) {
      final dbResult = await _databaseService.getLeaderboard();
      if (dbResult is Ok<List<WorkspaceLeaderboardUser>>) {
        final dbLeaderboard = dbResult.value;
        if (dbLeaderboard.isNotEmpty) {
          _cachedLeaderboard = dbLeaderboard;
          notifyListeners();
          yield const Result.ok(null);
        }
      }
    }

    // Trigger API request
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
        _cachedLeaderboard = leaderboard;
        notifyListeners();

        final dbSaveResult = await _databaseService.setLeaderboard(
          _cachedLeaderboard!,
        );
        if (dbSaveResult is Error<void>) {
          _loggerService.log(
            LogLevel.warn,
            'databaseService.setLeaderboard failed',
            error: dbSaveResult.error,
          );
        }

        yield const Result.ok(null);
      case Error<List<WorkspaceLeaderboardUserResponse>>():
        _loggerService.log(
          LogLevel.warn,
          'workspaceLeaderboardApiService.loadLeaderboard failed',
          error: result.error,
          stackTrace: result.stackTrace,
        );
        yield Result.error(result.error);
    }
  }

  @override
  Future<void> purgeLeaderboardCache() async {
    _cachedLeaderboard = null;
    await _databaseService.clearLeaderboard();
  }
}
