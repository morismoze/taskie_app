import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import '../../../data/repositories/workspace/workspace_repository.dart';
import '../../../domain/models/workspace.dart';
import '../../../domain/use_cases/refresh_token_use_case.dart';
import '../../../utils/command.dart';

class AppDrawerViewModel extends ChangeNotifier {
  AppDrawerViewModel({
    required WorkspaceRepository workspaceRepository,
    required RefreshTokenUseCase refreshTokenUseCase,
  }) : _workspaceRepository = workspaceRepository,
       _refreshTokenUseCase = refreshTokenUseCase {
    loadWorkspaces = Command0(_loadWorkspaces);
    loadActiveWorkspaceId = Command0(_loadActiveWorkspaceId);
    leaveWorkspace = Command1(_leaveWorkspace);
    setActiveWorkspace = Command1(_setActiveWorkspace);
  }

  final WorkspaceRepository _workspaceRepository;
  final RefreshTokenUseCase _refreshTokenUseCase;
  final _log = Logger('AppDrawerViewModel');

  late Command0 loadWorkspaces;
  late Command0 loadActiveWorkspaceId;
  late Command1<void, String> leaveWorkspace;
  late Command1<void, String> setActiveWorkspace;

  List<Workspace> _workspaces = [];

  List<Workspace> get workspaces => _workspaces;

  String? _activeWorkspaceId;

  String? get activeWorkspaceId => _activeWorkspaceId;

  String? _inviteLink;

  String? get inviteLink => _inviteLink;

  Future<Result<void>> _loadActiveWorkspaceId() async {
    final result = await _workspaceRepository.getActiveWorkspaceId();

    switch (result) {
      case Ok():
        _activeWorkspaceId = result.value;
        notifyListeners();
      case Error():
        _log.warning('Failed to load active workspace ID', result.error);
    }

    return result;
  }

  Future<Result<void>> _loadWorkspaces() async {
    final result = await _workspaceRepository.getWorkspaces();

    switch (result) {
      case Ok():
        _workspaces = result.value;
        notifyListeners();
      case Error():
        _log.warning('Failed to load workspaces', result.error);
    }

    return result;
  }

  Future<Result<void>> _setActiveWorkspace(String workspaceId) async {
    final result = await _workspaceRepository.setActiveWorkspaceId(workspaceId);

    switch (result) {
      case Ok():
        _activeWorkspaceId = workspaceId;
        notifyListeners();
      case Error():
        _log.warning('Failed to set active workspace', result.error);
    }

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
        return Result.error(resultLeave.error);
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

    // We need to load workspaces again - this will load from repository cache, which was updated with the
    // given workspace by removing it from that cache list in WorkspaceRepository.leaveWorkspace function.
    await _loadWorkspaces();

    final resultSet = _setActiveWorkspace(_workspaces[0].id);

    return resultSet;
  }
}
