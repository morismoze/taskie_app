import '../../data/repositories/workspace/workspace/workspace_repository.dart';
import '../../data/repositories/workspace/workspace_invite/workspace_invite_repository.dart';
import '../../utils/command.dart';
import 'active_workspace_change_use_case.dart';
import 'refresh_token_use_case.dart';

class JoinWorkspaceUseCase {
  JoinWorkspaceUseCase({
    required WorkspaceInviteRepository workspaceInviteRepository,
    required WorkspaceRepository workspaceRepository,
    required ActiveWorkspaceChangeUseCase activeWorkspaceChangeUseCase,
    required RefreshTokenUseCase refreshTokenUseCase,
  }) : _workspaceInviteRepository = workspaceInviteRepository,
       _workspaceRepository = workspaceRepository,
       _activeWorkspaceChangeUseCase = activeWorkspaceChangeUseCase,
       _refreshTokenUseCase = refreshTokenUseCase;

  final WorkspaceInviteRepository _workspaceInviteRepository;
  final WorkspaceRepository _workspaceRepository;
  final ActiveWorkspaceChangeUseCase _activeWorkspaceChangeUseCase;
  final RefreshTokenUseCase _refreshTokenUseCase;

  /// On workspace join we need to do 4 things:
  /// 1. Join the workspace,
  /// 2. Refresh the access token, since we keep role per workspace in it,
  /// 3. Re-fetch the user with updated roles (new workspace with Member role)
  /// 3. Add the joined workspace to [WorkspaceRepository]'s cache
  ///
  /// This is made into separate use-case because the same logic is used on
  /// /workspaces/create and /workspaces/join/:inviteToken routes.
  ///
  /// Returns `workspaceId` of the newly joined workspace,
  Future<Result<String>> joinWorkspace(String inviteToken) async {
    final resultJoin = await _workspaceInviteRepository.joinWorkspace(
      inviteToken: inviteToken,
    );

    switch (resultJoin) {
      case Ok():
        break;
      case Error():
        return Result.error(resultJoin.error);
    }

    // We need to refresh the access token since we keep list of roles with
    // corresponding workspaces inside the access token.
    final resultRefresh = await _refreshTokenUseCase.refreshAcessToken();

    switch (resultRefresh) {
      case Ok():
        break;
      case Error():
        return Result.error(resultRefresh.error);
    }

    final newWorkspace = resultJoin.value;
    final resultAddWorkspace = await _workspaceRepository.addWorkspace(
      workspace: newWorkspace,
    );

    switch (resultAddWorkspace) {
      case Ok():
        break;
      case Error():
        return Result.error(resultAddWorkspace.error);
    }

    final resultWorkspaceChange = await _activeWorkspaceChangeUseCase
        .handleWorkspaceChange(newWorkspace.id);

    switch (resultWorkspaceChange) {
      case Ok():
        return Result.ok(newWorkspace.id);
      case Error():
        return Result.error(resultWorkspaceChange.error);
    }
  }
}
