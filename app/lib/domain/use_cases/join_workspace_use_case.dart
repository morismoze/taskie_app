import 'package:logging/logging.dart';

import '../../data/repositories/user/user_repository.dart';
import '../../data/repositories/workspace/workspace/workspace_repository.dart';
import '../../data/repositories/workspace/workspace_invite/workspace_invite_repository.dart';
import '../../utils/command.dart';
import 'refresh_token_use_case.dart';

class JoinWorkspaceUseCase {
  JoinWorkspaceUseCase({
    required WorkspaceInviteRepository workspaceInviteRepository,
    required WorkspaceRepository workspaceRepository,
    required UserRepository userRepository,
    required RefreshTokenUseCase refreshTokenUseCase,
  }) : _workspaceInviteRepository = workspaceInviteRepository,
       _workspaceRepository = workspaceRepository,
       _userRepository = userRepository,
       _refreshTokenUseCase = refreshTokenUseCase;

  final WorkspaceInviteRepository _workspaceInviteRepository;
  final WorkspaceRepository _workspaceRepository;
  final UserRepository _userRepository;
  final RefreshTokenUseCase _refreshTokenUseCase;

  final _log = Logger('JoinWorkspaceUseCase');

  /// On workspace join we need to do two things:
  /// 1. Join the workspace,
  /// 2. Refresh the access token, since we keep role per workspace in it,
  /// 3. Re-fetch the user with updated roles (new workspace with Manager role)
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
        _log.warning('Failed to join workspace', resultJoin.error);
        return Result.error(resultJoin.error);
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

    final resultUser = await _userRepository.loadUser(forceFetch: true);

    switch (resultUser) {
      case Ok():
        break;
      case Error():
        _log.warning('Failed to refresh the user', resultUser.error);
        return Result.error(resultUser.error);
    }

    final newWorkspace = resultJoin.value;

    _workspaceRepository.addWorkspace(workspace: newWorkspace);

    return Result.ok(newWorkspace.id);
  }
}
