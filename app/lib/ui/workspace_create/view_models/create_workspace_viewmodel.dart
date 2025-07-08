import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import '../../../data/repositories/user/user_repository.dart';
import '../../../data/repositories/workspace/workspace_repository.dart';
import '../../../domain/models/user.dart';
import '../../../domain/models/workspace.dart';
import '../../../domain/use_cases/create_workspace_use_case.dart';
import '../../../utils/command.dart';

class CreateWorkspaceScreenViewModel extends ChangeNotifier {
  CreateWorkspaceScreenViewModel({
    required WorkspaceRepository workspaceRepository,
    required UserRepository userRepository,
    required CreateWorkspaceUseCase createWorkspaceUseCase,
  }) : _workspaceRepository = workspaceRepository,
       _userRepository = userRepository,
       _createWorkspaceUseCase = createWorkspaceUseCase {
    loadUser = Command0(_loadUser)..execute();
    loadWorkspaces = Command0(_loadWorkspaces)..execute();
    createWorkspace = Command1(_createWorkspace);
  }

  final WorkspaceRepository _workspaceRepository;
  final UserRepository _userRepository;
  final CreateWorkspaceUseCase _createWorkspaceUseCase;
  final _log = Logger('CreateWorkspaceScreenViewModel');

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

  Future<Result<void>> _loadWorkspaces() async {
    final result = await _workspaceRepository.getWorkspaces();

    switch (result) {
      case Ok():
        _workspaces = result.value;
      case Error():
        _log.warning('Failed to load workspaces', result.error);
    }

    notifyListeners();
    return result;
  }

  Future<Result<void>> _createWorkspace((String, String?) details) async {
    final (name, description) = details;

    final resultCreate = await _createWorkspaceUseCase.createWorkspace(
      name: name,
      description: description,
    );

    return resultCreate;
  }
}
