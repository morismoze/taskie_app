import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

import '../../../../data/repositories/workspace/workspace/workspace_repository.dart';
import '../../../../domain/models/workspace.dart';
import '../../../../domain/use_cases/refresh_token_use_case.dart';
import '../../../../utils/command.dart';

class AppDrawerViewModel extends ChangeNotifier {
  AppDrawerViewModel({
    required String workspaceId,
    required WorkspaceRepository workspaceRepository,
    required RefreshTokenUseCase refreshTokenUseCase,
  }) : _activeWorkspaceId = workspaceId,
       _workspaceRepository = workspaceRepository,
       _refreshTokenUseCase = refreshTokenUseCase {
    loadWorkspaces = Command0(_loadWorkspaces);
    leaveWorkspace = Command1(_leaveWorkspace);
  }

  final String _activeWorkspaceId;
  final WorkspaceRepository _workspaceRepository;
  final RefreshTokenUseCase _refreshTokenUseCase;
  final _log = Logger('AppDrawerViewModel');

  late Command0 loadWorkspaces;
  late Command1<void, String> leaveWorkspace;

  String get activeWorkspaceId => _activeWorkspaceId;

  List<Workspace> _workspaces = [];

  List<Workspace> get workspaces => _workspaces;

  String? _inviteLink;

  String? get inviteLink => _inviteLink;

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
    return await _loadWorkspaces();
  }
}
