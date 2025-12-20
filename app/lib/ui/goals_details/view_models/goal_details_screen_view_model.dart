import 'package:flutter/foundation.dart';

import '../../../data/repositories/workspace/workspace_goal/workspace_goal_repository.dart';
import '../../../domain/models/workspace_goal.dart';
import '../../../utils/command.dart';

class GoalDetailsScreenViewModel extends ChangeNotifier {
  GoalDetailsScreenViewModel({
    required String workspaceId,
    required String goalId,
    required WorkspaceGoalRepository workspaceGoalRepository,
  }) : _activeWorkspaceId = workspaceId,
       _goalId = goalId,
       _workspaceGoalRepository = workspaceGoalRepository {
    _loadWorkspaceGoalDetails();
  }

  final String _activeWorkspaceId;
  final String _goalId;
  final WorkspaceGoalRepository _workspaceGoalRepository;

  String get activeWorkspaceId => _activeWorkspaceId;

  WorkspaceGoal? _details;

  WorkspaceGoal? get details => _details;

  Result<void> _loadWorkspaceGoalDetails() {
    final result = _workspaceGoalRepository.loadGoalDetails(goalId: _goalId);
    switch (result) {
      case Ok():
        _details = result.value;
        notifyListeners();
        return const Result.ok(null);
      case Error():
        return result;
    }
  }
}
