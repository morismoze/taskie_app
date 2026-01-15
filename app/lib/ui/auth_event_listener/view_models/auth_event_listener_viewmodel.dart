import 'package:flutter/material.dart';

import '../../../data/repositories/user/user_repository.dart';
import '../../../data/repositories/workspace/workspace/workspace_repository.dart';
import '../../../domain/use_cases/active_workspace_change_use_case.dart';
import '../../../domain/use_cases/sign_out_use_case.dart';
import '../../../utils/command.dart';

// There are 5 important cases:
// 1. The user got kicked out from the currently active workspace. On the backend
// we edit that user's current session, and on that user's next auth guarded request
// the user will get 401 and then on the frontend do token refresh. After that, the
// failed request will retry and if it was towards an endpoint which is guarded by the
// role or membership, user will get 403 back. ForbiddenInterceptor will catch that and
// emit ApiErrorCode.workspaceAccessRevoked code, which we will listen in the auth event listener.
// 2. The user got kicked out from a not currently active workspace. Once user changes
// active workspace to that one, point 1. (workspace membership guarded endpoint) will happen.
// 3. The user got his role downgraded for the currently active workspace. On the backend we
// edit that user's current session, and on that user's next auth guarded request the user will
// get 401 and then on the frontend do token refresh. After that, the failed request will retry
// and if it was towards an endpoint which is guarded by the role or membership, user will get
// 403 back. ForbiddenInterceptor will catch that and emit ApiErrorCode.insufficientPermissions
// code, which we will listen in the auth event listener.
// 4. The user got his role upgraded for the currently active workspace. On the backend we edit
// that user's current session, and on that user's next auth guarded request the user will get
// 401 and then on the frontend do token refresh. After that user will have new role for the
// current workspace in the access token, but not yet in the user repository. Once user does
// pull to refresh on the homepage, user will be force fetched with the new role.
// 5. Token refresh failed - we want to sign out the user locally using the SignOutUseCase

class AuthEventListenerViewmodel extends ChangeNotifier {
  AuthEventListenerViewmodel({
    required WorkspaceRepository workspaceRepository,
    required UserRepository userRepository,
    required ActiveWorkspaceChangeUseCase activeWorkspaceChangeUseCase,
    required SignOutUseCase signOutUseCase,
  }) : _workspaceRepository = workspaceRepository,
       _userRepository = userRepository,
       _activeWorkspaceChangeUseCase = activeWorkspaceChangeUseCase,
       _signOutUseCase = signOutUseCase {
    handleWorkspaceRoleChange = Command0(_handleWorkspaceRoleChange);
    handleRemovalFromWorkspace = Command0(_handleRemovalFromWorkspace);
    signOut = Command0(_signOut);
    signOutLocally = Command0(_signOutLocally);
  }

  final WorkspaceRepository _workspaceRepository;
  final UserRepository _userRepository;
  final ActiveWorkspaceChangeUseCase _activeWorkspaceChangeUseCase;
  final SignOutUseCase _signOutUseCase;

  String? get activeWorkspaceId => _workspaceRepository.activeWorkspaceId;

  late Command0 handleWorkspaceRoleChange;

  /// Returns the workspaceId which to navigate to or
  /// null if there are no more workspaces user is part of
  late Command0<String?> handleRemovalFromWorkspace;
  late Command0 signOut;
  late Command0 signOutLocally;

  Future<Result<void>> _handleWorkspaceRoleChange() async {
    // For this case we only need to re-fetch the user (token refresh already happened)
    final resultUser = await _userRepository.loadUser(forceFetch: true).last;

    switch (resultUser) {
      case Ok():
        return const Result.ok(null);
      case Error():
        return Result.error(resultUser.error);
    }
  }

  Future<Result<String?>> _handleRemovalFromWorkspace() async {
    // For this case we need to re-fetch workspaces list and the user.
    // User is re-fetched in the ActiveWorkspaceChangeUseCase.
    // After those two request are successful we take first workspace
    // from the list and navigate to it. If the user is not part
    // of any more workspaces after this, we need to navigate the user
    // to the initial workspace create screen.
    final resultLoadWorkspaces = await _workspaceRepository
        .loadWorkspaces()
        .last;

    switch (resultLoadWorkspaces) {
      case Ok():
        if (resultLoadWorkspaces.value.isEmpty) {
          // User is not part of any more workspace
          return const Result.ok(null);
        }
        break;
      case Error():
        return Result.error(resultLoadWorkspaces.error);
    }

    final firstWorkspaceId = resultLoadWorkspaces.value.first.id;
    // handleWorkspaceChange already re-fetches user
    final resultWorkspaceChange = await _activeWorkspaceChangeUseCase
        .handleWorkspaceChange(firstWorkspaceId);

    switch (resultWorkspaceChange) {
      case Ok():
        return Result.ok(firstWorkspaceId);
      case Error():
        return Result.error(resultWorkspaceChange.error);
    }
  }

  Future<Result<void>> _signOut() async {
    final result = await _signOutUseCase.signOut();

    switch (result) {
      case Ok():
        return const Result.ok(null);
      case Error():
        return result;
    }
  }

  Future<Result<void>> _signOutLocally() async {
    await _signOutUseCase.forceLocalSignOut();
    return const Result.ok(null);
  }
}
