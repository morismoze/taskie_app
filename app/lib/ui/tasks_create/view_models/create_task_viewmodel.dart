import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import '../../../data/repositories/workspace/workspace_repository.dart';
import '../../../data/services/api/user/models/response/user_response.dart';
import '../../../domain/models/workspace_user.dart';
import '../../../utils/command.dart';

class CreateTaskViewmodel extends ChangeNotifier {
  CreateTaskViewmodel({
    required String workspaceId,
    required WorkspaceRepository workspaceRepository,
  }) : _workspaceRepository = workspaceRepository {
    _loadWorkspaceUsers(workspaceId);
    createTask = Command1(_createTask);
  }

  final WorkspaceRepository _workspaceRepository;
  final _log = Logger('CreateTaskViewmodel');

  late Command1<void, (String, String, List<String>, String?, int)> createTask;

  List<WorkspaceUser> _workspaceUsers = [];

  List<WorkspaceUser> get workspaceUsers => _workspaceUsers;

  Future<Result<void>> _loadWorkspaceUsers(String workspaceId) async {
    final result = await _workspaceRepository.getWorkspaceUsers(
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
    (String, String, List<String>, String?, int) details,
  ) async {
    print(details);
    return Future.delayed(Duration.zero);
  }
}
