import 'package:flutter/material.dart';

import '../../../data/repositories/workspace/workspace_goal/workspace_goal_repository.dart';
import '../../../data/repositories/workspace/workspace_user/workspace_user_repository.dart';
import '../../../data/services/api/user/models/response/user_response.dart';
import '../../../domain/models/workspace_user.dart';
import '../../../utils/command.dart';

class CreateGoalScreenViewmodel extends ChangeNotifier {
  CreateGoalScreenViewmodel({
    required String workspaceId,
    required WorkspaceUserRepository workspaceUserRepository,
    required WorkspaceGoalRepository workspaceGoalRepository,
  }) : _activeWorkspaceId = workspaceId,
       _workspaceUserRepository = workspaceUserRepository,
       _workspaceGoalRepository = workspaceGoalRepository {
    _workspaceUserRepository.addListener(_onWorkspaceUsersChanged);
    loadWorkspaceMembers = Command0(_loadWorkspaceMembers)..execute();
    createGoal = Command1(_createGoal);
    loadWorkspaceUserAccumulatedPoints = Command1(
      _loadWorkspaceUserAccumulatedPoints,
    );
  }

  final WorkspaceUserRepository _workspaceUserRepository;
  final WorkspaceGoalRepository _workspaceGoalRepository;

  late Command0 loadWorkspaceMembers;
  late Command1<void, String> loadWorkspaceUserAccumulatedPoints;
  late Command1<
    void,
    (String title, String? description, String assigneeId, int requiredPoints)
  >
  createGoal;

  final String _activeWorkspaceId;

  String get activeWorkspaceId => _activeWorkspaceId;

  int? _workspaceUserAccumulatedPoints;

  int? get workspaceUserAccumulatedPoints => _workspaceUserAccumulatedPoints;

  List<WorkspaceUser> get workspaceMembers =>
      _workspaceUserRepository.users
          ?.where((user) => user.role == WorkspaceRole.member)
          .toList() ??
      [];

  void _onWorkspaceUsersChanged() {
    notifyListeners();
  }

  Future<Result<void>> _loadWorkspaceMembers() async {
    final result = await firstOkOrLastError(
      _workspaceUserRepository.loadWorkspaceUsers(
        workspaceId: _activeWorkspaceId,
        // Force fetch so we always have up-to-date users on this screen
        forceFetch: true,
      ),
    );

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
        _workspaceUserAccumulatedPoints = result.value;
        notifyListeners();
        return const Result.ok(null);
      case Error():
        return result;
    }
  }

  Future<Result<void>> _createGoal(
    (String title, String? description, String assigneeId, int requiredPoints)
    details,
  ) async {
    final (title, description, assigneeId, requiredPoints) = details;
    final result = await _workspaceGoalRepository.createGoal(
      _activeWorkspaceId,
      title: title,
      description: description,
      assignee: assigneeId,
      requiredPoints: requiredPoints,
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
    _workspaceUserRepository.removeListener(_onWorkspaceUsersChanged);
    super.dispose();
  }
}
