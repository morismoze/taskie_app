import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import '../../../data/repositories/user/user_repository.dart';
import '../../../data/repositories/workspace/workspace_repository.dart';
import '../../../domain/models/user.dart';
import '../../../utils/command.dart';

class TasksViewModel extends ChangeNotifier {
  TasksViewModel({
    required UserRepository userRepository,
    required WorkspaceRepository workspaceRepository,
  }) : _userRepository = userRepository,
       _workspaceRepository = workspaceRepository {
    loadUser = Command0(_loadUser)..execute();
    loadWorkspaces = Command0(_loadWorkspaces)..execute();
  }

  final UserRepository _userRepository;
  final WorkspaceRepository _workspaceRepository;
  final _log = Logger('TasksViewModel');

  late Command0 loadUser;
  late Command0 loadWorkspaces;

  User? _user;

  User? get user => _user;

  Future<Result<void>> _loadUser() async {
    final result = await _userRepository.getUser();

    switch (result) {
      case Ok():
        _user = result.value;
        notifyListeners();
      case Error():
        _log.warning('Failed to load user', result.error);
    }

    return result;
  }

  Future<Result<void>> _loadWorkspaces() async {
    final result = await _workspaceRepository.getWorkspaces();

    switch (result) {
      case Ok():
        break;
      case Error():
        _log.warning('Failed to load workspaces', result.error);
    }

    return result;
  }
}
