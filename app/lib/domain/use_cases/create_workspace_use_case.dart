import 'package:logging/logging.dart';

import '../../data/repositories/user/user_repository.dart';
import '../../data/repositories/workspace/workspace/workspace_repository.dart';
import '../../utils/command.dart';
import 'refresh_token_use_case.dart';

class CreateWorkspaceUseCase {
  CreateWorkspaceUseCase({
    required WorkspaceRepository workspaceRepository,
    required UserRepository userRepository,
    required RefreshTokenUseCase refreshTokenUseCase,
  }) : _workspaceRepository = workspaceRepository,
       _userRepository = userRepository,
       _refreshTokenUseCase = refreshTokenUseCase;

  final WorkspaceRepository _workspaceRepository;
  final UserRepository _userRepository;
  final RefreshTokenUseCase _refreshTokenUseCase;

  final _log = Logger('CreateWorkspaceUseCase');

  /// On workspace creation we need to do two things:
  /// 1. Create the workspace
  /// 3. Refresh the access token, since we keep role per workspace in it
  /// 2. Re-fetch user's roles.
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

    // We also need to refresh the user since user endpoint also returns
    // role per each workspace.
    // TODO: is it maybe better to manually update the user cache?
    final resultUser = await _userRepository.getUser(forceFetch: true);

    switch (resultUser) {
      case Ok():
        break;
      case Error():
        _log.warning('Failed to refresh user', resultUser.error);
        return Result.error(resultUser.error);
    }

    return Result.ok(resultCreate.value);
  }
}
