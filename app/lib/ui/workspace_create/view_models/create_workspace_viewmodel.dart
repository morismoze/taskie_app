import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import '../../../data/repositories/user/user_repository.dart';
import '../../../data/repositories/workspace/workspace_repository.dart';
import '../../../domain/models/user.dart';
import '../../../domain/models/workspace.dart';
import '../../../domain/use_cases/refresh_token_use_case.dart';
import '../../../utils/command.dart';

class CreateWorkspaceViewModel extends ChangeNotifier {
  CreateWorkspaceViewModel({
    required WorkspaceRepository workspaceRepository,
    required UserRepository userRepository,
    required RefreshTokenUseCase refreshTokenUseCase,
  }) : _workspaceRepository = workspaceRepository,
       _userRepository = userRepository,
       _refreshTokenUseCase = refreshTokenUseCase {
    loadUser = Command0(_loadUser)..execute();
    loadWorkspaces = Command0(_loadWorkspaces)..execute();
    createWorkspace = Command1(_createWorkspace);
  }

  final WorkspaceRepository _workspaceRepository;
  final UserRepository _userRepository;
  final RefreshTokenUseCase _refreshTokenUseCase;
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
        return Result.error(resultCreate.error);
    }

    // We need to refresh the access token since we keep list of roles with
    // corresponding workspaces inside the access token.
    final resultRefresh = await _refreshTokenUseCase.refreshAcessToken();

    switch (resultRefresh) {
      case Ok():
        break;
      case Error():
        _log.warning('Failed to refresh token', resultRefresh.error);
        return Result.error(resultRefresh.error);
    }

    return resultCreate;
  }
}
