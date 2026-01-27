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
    final details = _loadWorkspaceGoalDetails();
    _workspaceUserRepository.addListener(_onWorkspaceUsersChanged);
    workspaceGoalRepository.addListener(_onWorkspaceGoalsChanged);
    // This is loading for the select field for adding new assignees
    loadWorkspaceMembers = Command1(_loadWorkspaceMembers)
      ..execute(workspaceId);

    if (details is Ok<WorkspaceGoal?> && details.value != null) {
      loadWorkspaceUserAccumulatedPoints = Command1(
        _loadWorkspaceUserAccumulatedPoints,
      )..execute(details.value!.id);
    }

    editGoalDetails = Command1(_editGoalDetails);
    closeGoal = Command0(_closeGoal);
  }

  final String _activeWorkspaceId;
  final String _goalId;
  final WorkspaceGoalRepository _workspaceGoalRepository;
  final WorkspaceUserRepository _workspaceUserRepository;

  late Command1<void, String> loadWorkspaceMembers;
  late Command1<void, String> loadWorkspaceUserAccumulatedPoints;
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

  final ValueNotifier<int?> _workspaceUserAccumulatedPointsNotifier =
      ValueNotifier(null);

  ValueListenable<int?> get workspaceUserAccumulatedPointsListenable =>
      _workspaceUserAccumulatedPointsNotifier;

  void _onWorkspaceUsersChanged() {
    notifyListeners();
  }

  void _onWorkspaceGoalsChanged() {
    _loadWorkspaceGoalDetails();
  }

  Result<WorkspaceGoal?> _loadWorkspaceGoalDetails() {
    final result = _workspaceGoalRepository.loadGoalDetails(goalId: _goalId);

    switch (result) {
      case Ok():
        _details = result.value;
        notifyListeners();
        return Result.ok(_details);
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
    // Using .last so we always have up-to-date users on this screen
    // meaning it will always go to the origin when it can
    final result = await _workspaceUserRepository
        .loadWorkspaceUsers(workspaceId: workspaceId)
        .last;

    switch (result) {
      case Ok():
        return const Result.ok(null);
      case Error():
        return result;
    }
  }

  Future<Result<void>> _loadWorkspaceUserAccumulatedPoints(
    String workspaceUserId,
  ) async {
    final result = await _workspaceUserRepository
        .getWorkspaceUserAccumulatedPoints(
          workspaceId: _activeWorkspaceId,
          workspaceUserId: workspaceUserId,
        );

    switch (result) {
      case Ok():
        _workspaceUserAccumulatedPointsNotifier.value = result.value;
        notifyListeners();
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

    // If nothing changed, return
    if (!hasTitleChanged &&
        !hasDescriptionChanged &&
        !hasRequiredPointsChanged &&
        !hasAssigneeChanged) {
      return const Result.ok(null);
    }

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
