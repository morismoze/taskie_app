import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

import '../../../data/repositories/workspace/workspace_goal/workspace_goal_repository.dart';
import '../../../data/services/api/value_patch.dart';
import '../../../domain/models/workspace_goal.dart';
import '../../../utils/command.dart';

class GoalDetailsEditScreenViewModel extends ChangeNotifier {
  GoalDetailsEditScreenViewModel({
    required String workspaceId,
    required String goalId,
    required WorkspaceGoalRepository workspaceGoalRepository,
  }) : _activeWorkspaceId = workspaceId,
       _goalId = goalId,
       _workspaceGoalRepository = workspaceGoalRepository {
    _loadWorkspaceGoalDetails();
    workspaceGoalRepository.addListener(_onWorkspaceGoalsChanged);
    editGoalDetails = Command1(_editGoalDetails);
    closeGoal = Command0(_closeGoal);
  }

  final String _activeWorkspaceId;
  final String _goalId;
  final WorkspaceGoalRepository _workspaceGoalRepository;
  final _log = Logger('GoalDetailsEditScreenViewModel');

  late Command0 closeGoal;
  late Command1<
    void,
    (
      String? title,
      String? description,
      int? requiredPoints,
      String? assigneeId,
    )
  >
  editGoalDetails;

  String get activeWorkspaceId => _activeWorkspaceId;

  WorkspaceGoal? _details;

  WorkspaceGoal? get details => _details;

  void _onWorkspaceGoalsChanged() {
    _loadWorkspaceGoalDetails();
  }

  Result<void> _loadWorkspaceGoalDetails() {
    final result = _workspaceGoalRepository.loadGoalDetails(goalId: _goalId);

    switch (result) {
      case Ok():
        _details = result.value;
        notifyListeners();
        return const Result.ok(null);
      case Error():
        _log.warning('Failed to load goal details', result.error);
        return result;
    }
  }

  Future<Result<void>> _editGoalDetails(
    (
      String? title,
      String? description,
      int? requiredPoints,
      String? assigneeId,
    )
    details,
  ) async {
    final (title, description, requiredPoints, assigneeId) = details;

    final hasTitleChanged = title != _details!.title;
    final hasDescriptionChanged = description != _details!.description;
    final hasRequiredPointsChanged = requiredPoints != _details!.requiredPoints;
    final hasAssigneeChanged = assigneeId != _details!.assignee.id;

    final result = await _workspaceGoalRepository.updateGoalDetails(
      _activeWorkspaceId,
      _details!.id,
      title: hasTitleChanged ? ValuePatch(title!) : null,
      description: hasDescriptionChanged ? ValuePatch(description) : null,
      requiredPoints: hasRequiredPointsChanged
          ? ValuePatch(requiredPoints!)
          : null,
      assigneeId: hasAssigneeChanged ? ValuePatch(assigneeId) : null,
    );

    switch (result) {
      case Ok():
        return const Result.ok(null);
      case Error():
        _log.warning('Failed to update goal details', result.error);
        return result;
    }
  }

  Future<Result<void>> _closeGoal() async {
    final result = await _workspaceGoalRepository.closeGoal(
      workspaceId: activeWorkspaceId,
      goalId: _goalId,
    );

    switch (result) {
      case Ok():
        return const Result.ok(null);
      case Error():
        _log.warning('Failed to close the goal', result.error);
        return result;
    }
  }

  @override
  void dispose() {
    _workspaceGoalRepository.removeListener(_onWorkspaceGoalsChanged);
    super.dispose();
  }
}
