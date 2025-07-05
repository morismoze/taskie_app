import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import '../../../data/repositories/auth/auth_repository.dart';
import '../../../data/repositories/user/user_repository.dart';
import '../../../data/repositories/workspace/workspace_repository.dart';
import '../../../domain/models/user.dart';
import '../../../domain/models/workspace.dart';
import '../../../utils/command.dart';

class CreateWorkspaceViewModel extends ChangeNotifier {
  CreateWorkspaceViewModel({
    required WorkspaceRepository workspaceRepository,
    required UserRepository userRepository,
    required AuthRepository authRepository,
  }) : _workspaceRepository = workspaceRepository,
       _userRepository = userRepository,
       _authRepository = authRepository {
    loadUser = Command0(_loadUser)..execute();
    loadWorkspaces = Command0(_loadWorkspaces)..execute();
    createWorkspace = Command1(_createWorkspace);
  }

  final WorkspaceRepository _workspaceRepository;
  final UserRepository _userRepository;
  final AuthRepository _authRepository;
  final _log = Logger('CreateWorkspaceViewModel');

  late Command0 loadUser;
  late Command0 loadWorkspaces;
  late Command1<void, (String name, String? description)> createWorkspace;

  User? _user;

  User? get user => _user;

  List<Workspace> _workspaces = [];

  List<Workspace> get workspaces => _workspaces;

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

  Future<Result<void>> _loadWorkspaces({bool forceFetch = false}) async {
    final result = await _workspaceRepository.getWorkspaces(
      forceFetch: forceFetch,
    );

    switch (result) {
      case Ok():
        _workspaces = result.value;
      case Error():
        _log.warning('Failed to load workspaces', result.error);
    }

    notifyListeners();
    return result;
  }

  Future<Result<Workspace>> _createWorkspace((String, String?) details) async {
    final (name, description) = details;

    final resultCreate = await _workspaceRepository.createWorkspace(
      name: name,
      description: description,
    );

    switch (resultCreate) {
      case Ok():
        break;
      case Error():
        _log.warning('Failed to create workspace', resultCreate.error);
    }

    // We need to refresh the access token since we keep list of roles with
    // corresponding workspaces inside the access token.
    final resultRefresh = await _authRepository.refreshAcessToken();

    switch (resultRefresh) {
      case Ok():
        break;
      case Error():
        _log.warning('Failed to refresh token', resultRefresh.error);
    }

    // We need to load workspaces again - this will load from repository cache, which was updated with the
    // given workspace by adding it to that cache list in WorkspaceRepository.createWorkspace function.
    await _loadWorkspaces();

    return resultCreate;
  }
}
