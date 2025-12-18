import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import '../../../data/repositories/workspace/workspace_task/workspace_task_repository.dart';
import '../../../data/repositories/workspace/workspace_user/workspace_user_repository.dart';
import '../../../data/services/api/user/models/response/user_response.dart';
import '../../../domain/models/workspace_user.dart';
import '../../../utils/command.dart';

class CreateTaskScreenViewmodel extends ChangeNotifier {
  CreateTaskScreenViewmodel({
    required String workspaceId,
    required WorkspaceUserRepository workspaceUserRepository,
    required WorkspaceTaskRepository workspaceTaskRepository,
  }) : _activeWorkspaceId = workspaceId,
       _workspaceUserRepository = workspaceUserRepository,
       _workspaceTaskRepository = workspaceTaskRepository {
    _workspaceUserRepository.addListener(_onWorkspaceUsersChanged);
    loadWorkspaceMembers = Command0(_loadWorkspaceMembers)..execute();
    createTask = Command1(_createTask);
  }

  final WorkspaceUserRepository _workspaceUserRepository;
  final WorkspaceTaskRepository _workspaceTaskRepository;
  final _log = Logger('CreateTaskScreenViewmodel');

  late Command0 loadWorkspaceMembers;
  late Command1<
    void,
    (
      String title,
      String? description,
      List<String> assigneeIds,
      int rewardPoints,
      DateTime? dueDate,
    )
  >
  createTask;

  final String _activeWorkspaceId;

  String get activeWorkspaceId => _activeWorkspaceId;

  void _onWorkspaceUsersChanged() {
    notifyListeners();
  }

  List<WorkspaceUser> get workspaceMembers =>
      _workspaceUserRepository.users
          ?.where((user) => user.role == WorkspaceRole.member)
          .toList() ??
      [];

  Future<Result<void>> _loadWorkspaceMembers() async {
    final result = await _workspaceUserRepository.loadWorkspaceUsers(
      workspaceId: _activeWorkspaceId,
    );

    switch (result) {
      case Ok():
        return const Result.ok(null);
      case Error():
        _log.warning('Failed to load workspace users', result.error);
        return result;
    }
  }

  Future<Result<void>> _createTask(
    (
      String title,
      String? description,
      List<String> assigneeIds,
      int rewardPoints,
      DateTime? dueDate,
    )
    details,
  ) async {
    final (title, description, assigneeIds, rewardPoints, dueDate) = details;
    final result = await _workspaceTaskRepository.createTask(
      _activeWorkspaceId,
      title: title,
      description: description,
      assignees: assigneeIds,
      rewardPoints: rewardPoints,
      dueDate: dueDate,
    );

    switch (result) {
      case Ok():
        return const Result.ok(null);
      case Error():
        _log.warning('Failed to create new task', result.error);
        return result;
    }
  }

  @override
  void dispose() {
    _workspaceUserRepository.removeListener(_onWorkspaceUsersChanged);
    super.dispose();
  }
}
