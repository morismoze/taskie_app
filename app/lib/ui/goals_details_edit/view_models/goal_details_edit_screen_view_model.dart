import 'package:flutter/foundation.dart';

import '../../../data/repositories/workspace/workspace_goal/workspace_goal_repository.dart';
import '../../../data/repositories/workspace/workspace_user/workspace_user_repository.dart';
import '../../../data/services/api/user/models/response/user_response.dart';
import '../../../data/services/api/value_patch.dart';
import '../../../domain/models/workspace_goal.dart';
import '../../../domain/models/workspace_user.dart';
import '../../../utils/command.dart';

class GoalDetailsEditScreenViewModel extends ChangeNotifier {
  GoalDetailsEditScreenViewModel({
    required String workspaceId,
    required String goalId,
    required WorkspaceGoalRepository workspaceGoalRepository,
    required WorkspaceUserRepository workspaceUserRepository,
  }) : _activeWorkspaceId = workspaceId,
       _goalId = goalId,
       _workspaceGoalRepository = workspaceGoalRepository,
       _workspaceUserRepository = workspaceUserRepository {
    _loadWorkspaceGoalDetails();
    _workspaceUserRepository.addListener(_onWorkspaceUsersChanged);
    workspaceGoalRepository.addListener(_onWorkspaceGoalsChanged);
    // This is loading for the select field for adding new assignees
    loadWorkspaceMembers = Command1(_loadWorkspaceMembers)
      ..execute(workspaceId);
    editGoalDetails = Command1(_editGoalDetails);
    closeGoal = Command0(_closeGoal);
  }

  final String _activeWorkspaceId;
  final String _goalId;
  final WorkspaceGoalRepository _workspaceGoalRepository;
  final WorkspaceUserRepository _workspaceUserRepository;

  late Command1<void, String> loadWorkspaceMembers;
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

  List<WorkspaceUser> get workspaceMembers =>
      _workspaceUserRepository.users
          ?.where((user) => user.role == WorkspaceRole.member)
          .toList() ??
      [];

  void _onWorkspaceUsersChanged() {
    notifyListeners();
  }

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
        // This can happen when a goal gets closed and removed from the cache
        // and the repository notifies listeners, in this case the goal details
        // edit screen VM, which then tries to load the details again in a split
        // second before goal is closed and user is navigated back to goals
        // screen. Hence why we return positive result.
        return const Result.ok(null);
    }
  }

  Future<Result<void>> _loadWorkspaceMembers(String workspaceId) async {
    final result = await _workspaceUserRepository.loadWorkspaceUsers(
      workspaceId: workspaceId,
    );

    switch (result) {
      case Ok():
        return const Result.ok(null);
      case Error():
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
      assigneeId: hasAssigneeChanged ? ValuePatch(assigneeId!) : null,
    );

    switch (result) {
      case Ok():
        return const Result.ok(null);
      case Error():
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
        return result;
    }
  }

  @override
  void dispose() {
    _workspaceGoalRepository.removeListener(_onWorkspaceGoalsChanged);
    _workspaceUserRepository.removeListener(_onWorkspaceUsersChanged);
    super.dispose();
  }
}
