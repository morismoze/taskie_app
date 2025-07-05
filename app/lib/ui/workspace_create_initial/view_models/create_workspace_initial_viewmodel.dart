import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import '../../../data/repositories/user/user_repository.dart';
import '../../../data/repositories/workspace/workspace_repository.dart';
import '../../../domain/models/user.dart';
import '../../../domain/models/workspace.dart';
import '../../../utils/command.dart';

class CreateWorkspaceInitialViewModel extends ChangeNotifier {
  CreateWorkspaceInitialViewModel({
    required WorkspaceRepository workspaceRepository,
    required UserRepository userRepository,
  }) : _workspaceRepository = workspaceRepository,
       _userRepository = userRepository {
    loadUser = Command0(_loadUser)..execute();
    createWorkspace = Command1(_createWorkspace);
  }

  final WorkspaceRepository _workspaceRepository;
  final UserRepository _userRepository;
  final _log = Logger('CreateWorkspaceInitialViewModel');

  late Command0 loadUser;
  late Command1<void, (String name, String? description)> createWorkspace;

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

    notifyListeners();
    return result;
  }

  Future<Result<Workspace>> _createWorkspace((String, String?) details) async {
    final (name, description) = details;

    final result = await _workspaceRepository.createWorkspace(
      name: name,
      description: description,
    );

    switch (result) {
      case Ok():
        break;
      case Error():
        _log.warning('Failed to create workspace', result.error);
    }

    // No need for calling loadWorkspaces here since this screen is on separate page

    return result;
  }
}
