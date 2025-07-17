import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import '../../../data/repositories/workspace/workspace_task/workspace_task_repository.dart';
import '../../../data/repositories/workspace/workspace_user/workspace_user_repository.dart';
import '../../../data/services/api/user/models/response/user_response.dart';
import '../../../domain/models/workspace_user.dart';
import '../../../utils/command.dart';

class CreateTaskViewmodel extends ChangeNotifier {
  CreateTaskViewmodel({
    required String workspaceId,
    required WorkspaceUserRepository workspaceUserRepository,
    required WorkspaceTaskRepository workspaceTaskRepository,
  }) : _activeWorkspaceId = workspaceId,
       _workspaceUserRepository = workspaceUserRepository,
       _workspaceTaskRepository = workspaceTaskRepository {
    loadWorkspaceMembers = Command1(_loadWorkspaceMembers)
      ..execute(workspaceId);
    createTask = Command1(_createTask);
  }

  final WorkspaceUserRepository _workspaceUserRepository;
  final WorkspaceTaskRepository _workspaceTaskRepository;
  final _log = Logger('CreateTaskViewmodel');

  late Command1<void, String> loadWorkspaceMembers;
  late Command1<void, (String, String, List<String>, int, String?)> createTask;

  final String _activeWorkspaceId;

  String get activeWorkspaceId => _activeWorkspaceId;

  List<WorkspaceUser> get workspaceMembers =>
      _workspaceUserRepository.users
          ?.where((user) => user.role == WorkspaceRole.member)
          .toList() ??
      [];

  Future<Result<void>> _loadWorkspaceMembers(String workspaceId) async {
    final result = await _workspaceUserRepository.loadWorkspaceUsers(
      workspaceId: workspaceId,
    );

    switch (result) {
      case Ok():
        break;
      case Error():
        _log.warning('Failed to load workspace users', result.error);
    }

    return result;
  }

  Future<Result<void>> _createTask(
    (String, String, List<String>, int, String?) details,
  ) async {
    final (title, description, assigneeIds, rewardPoints, dueDate) = details;
    final result = await _workspaceTaskRepository.createTask(
      _activeWorkspaceId,
      title: title,
      description: description,
      assignees: assigneeIds,
      rewardPoints: rewardPoints,
      dueData: dueDate,
    );

    switch (result) {
      case Ok():
        break;
      case Error():
        _log.warning('Failed to create new task', result.error);
    }

    return result;
  }
}
