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
    _loadWorkspaceUsers(workspaceId);
    createTask = Command1(_createTask);
  }

  final String _activeWorkspaceId;
  final WorkspaceUserRepository _workspaceUserRepository;
  final WorkspaceTaskRepository _workspaceTaskRepository;
  final _log = Logger('CreateTaskViewmodel');

  late Command1<void, (String, String, List<String>, int, String?)> createTask;

  List<WorkspaceUser> _workspaceUsers = [];

  List<WorkspaceUser> get workspaceUsers => _workspaceUsers;

  Future<Result<void>> _loadWorkspaceUsers(String workspaceId) async {
    final result = await _workspaceUserRepository.getWorkspaceUsers(
      workspaceId: workspaceId,
    );

    switch (result) {
      case Ok():
        _workspaceUsers = result.value
            .where((user) => user.role == WorkspaceRole.member)
            .toList();
        notifyListeners();
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
