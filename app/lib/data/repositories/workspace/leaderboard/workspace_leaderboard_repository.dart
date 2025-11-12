import 'package:flutter/material.dart';

import '../../../../domain/models/workspace_leaderboard_user.dart';
import '../../../../utils/command.dart';

abstract class WorkspaceLeaderboardRepository extends ChangeNotifier {
  List<WorkspaceLeaderboardUser>? get leaderboard;

  Future<Result<void>> loadLeaderboard({
    required String workspaceId,
    bool forceFetch,
  });

  void purgeLeaderboardCache();
}
