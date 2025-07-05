import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import '../../../data/repositories/auth/auth_repository.dart';
import '../../../data/repositories/workspace/workspace_repository.dart';
import '../../../domain/models/workspace.dart';
import '../../../utils/command.dart';

class AppDrawerViewModel extends ChangeNotifier {
  AppDrawerViewModel({
    required WorkspaceRepository workspaceRepository,
    required AuthRepository authRepository,
  }) : _workspaceRepository = workspaceRepository,
       _authRepository = authRepository {
    loadWorkspaces = Command0(_loadWorkspaces);
    leaveWorkspace = Command1(_leaveWorkspace);
    setActiveWorkspace = Command1(_setActiveWorkspace);
  }

  final WorkspaceRepository _workspaceRepository;
  final AuthRepository _authRepository;
  final _log = Logger('AppDrawerViewModel');

  late Command0 loadWorkspaces;
  late Command1<void, String> leaveWorkspace;
  late Command1<void, String> setActiveWorkspace;

  List<Workspace> _workspaces = [];

  List<Workspace> get workspaces => _workspaces;

  Future<String?> get activeWorkspaceId =>
      _workspaceRepository.activeWorkspaceId;

  String? _inviteLink;

  String? get inviteLink => _inviteLink;

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

  Future<Result<void>> _setActiveWorkspace(String workspaceId) async {
    final result = await _workspaceRepository.setActiveWorkspaceId(workspaceId);

    switch (result) {
      case Ok():
        break;
      case Error():
        _log.warning('Failed to set active workspace', result.error);
    }

    notifyListeners();
    return result;
  }

  Future<Result<void>> _leaveWorkspace(String workspaceId) async {
    final resultLeave = await _workspaceRepository.leaveWorkspace(
      workspaceId: workspaceId,
    );

    switch (resultLeave) {
      case Ok():
        break;
      case Error():
        _log.warning('Failed to leave the workspace', resultLeave.error);
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
    // given workspace by removing it from that cache list in WorkspaceRepository.leaveWorkspace function.
    final resultLoad = _loadWorkspaces();

    return resultLoad;
  }
}
