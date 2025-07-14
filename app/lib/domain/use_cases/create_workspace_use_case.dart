import 'package:logging/logging.dart';

import '../../data/repositories/workspace/workspace/workspace_repository.dart';
import '../../utils/command.dart';
import 'active_workspace_change_use_case.dart';
import 'refresh_token_use_case.dart';

class CreateWorkspaceUseCase {
  CreateWorkspaceUseCase({
    required WorkspaceRepository workspaceRepository,
    required RefreshTokenUseCase refreshTokenUseCase,
    required ActiveWorkspaceChangeUseCase activeWorkspaceChangeUseCase,
  }) : _workspaceRepository = workspaceRepository,
       _refreshTokenUseCase = refreshTokenUseCase,
       _activeWorkspaceChangeUseCase = activeWorkspaceChangeUseCase;

  final WorkspaceRepository _workspaceRepository;
  final RefreshTokenUseCase _refreshTokenUseCase;
  final ActiveWorkspaceChangeUseCase _activeWorkspaceChangeUseCase;

  final _log = Logger('CreateWorkspaceUseCase');

  /// On workspace creation we need to do two things:
  /// 1. Create the workspace,
  /// 2. Refresh the access token, since we keep role per workspace in it,
  /// 4. Do post workspace change flow ([ActiveWorkspaceChangeUseCase]).
  ///
  /// This is made into separate use-case because the same logic used on /workspaces/create
  /// and /workspaces/create/initial routes.
  ///
  /// Returns `workspaceId` of the newly created workspace,
  Future<Result<String>> createWorkspace({
    required String name,
    String? description,
  }) async {
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

    final newWorkspaceId = resultCreate.value;

    final result = await _activeWorkspaceChangeUseCase.handleWorkspaceChange(
      newWorkspaceId,
    );

    switch (result) {
      case Ok():
        return resultCreate;
      case Error():
        _log.warning('Failed to change active workspace', result.error);
        return Result.error(result.error);
    }
  }
}
