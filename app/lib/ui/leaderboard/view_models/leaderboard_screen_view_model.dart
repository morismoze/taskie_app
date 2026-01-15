import 'package:flutter/foundation.dart';

import '../../../data/repositories/workspace/leaderboard/workspace_leaderboard_repository.dart';
import '../../../domain/models/workspace_leaderboard_user.dart';
import '../../../utils/command.dart';

class LeaderboardScreenViewModel extends ChangeNotifier {
  LeaderboardScreenViewModel({
    required String workspaceId,
    required WorkspaceLeaderboardRepository workspaceLeaderboardRepository,
  }) : _activeWorkspaceId = workspaceId,
       _workspaceLeaderboardRepository = workspaceLeaderboardRepository {
    _workspaceLeaderboardRepository.addListener(_onLeaderboardChanged);
    loadLeaderboard = Command1(_loadLeaderboard)..execute(null);
  }

  final String _activeWorkspaceId;
  final WorkspaceLeaderboardRepository _workspaceLeaderboardRepository;

  late Command1<void, bool?> loadLeaderboard;

  String get activeWorkspaceId => _activeWorkspaceId;

  List<WorkspaceLeaderboardUser>? get leaderboard {
    final leaderbard = _workspaceLeaderboardRepository.leaderboard;

    if (leaderbard == null) {
      return null;
    }

    final sortedLeaderboard = List<WorkspaceLeaderboardUser>.from(leaderbard);

    // Filter out users whose accumulated points equal to 0
    sortedLeaderboard.removeWhere((lu) => lu.accumulatedPoints == 0);

    return sortedLeaderboard;
  }

  void _onLeaderboardChanged() {
    notifyListeners();
  }

  Future<Result<void>> _loadLeaderboard(bool? forceFetch) async {
    final result = await _workspaceLeaderboardRepository
        .loadLeaderboard(
          workspaceId: activeWorkspaceId,
          forceFetch: forceFetch ?? false,
        )
        .last;

    switch (result) {
      case Ok():
        return const Result.ok(null);
      case Error():
        return result;
    }
  }

  @override
  void dispose() {
    _workspaceLeaderboardRepository.removeListener(_onLeaderboardChanged);
    super.dispose();
  }
}
