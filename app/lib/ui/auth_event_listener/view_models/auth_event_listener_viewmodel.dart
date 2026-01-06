import 'package:flutter/material.dart';

import '../../../data/repositories/user/user_repository.dart';
import '../../../data/repositories/workspace/workspace/workspace_repository.dart';
import '../../../domain/use_cases/active_workspace_change_use_case.dart';
import '../../../utils/command.dart';

// There are 4 important cases:
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

class AuthEventListenerViewmodel extends ChangeNotifier {
  AuthEventListenerViewmodel({
    required WorkspaceRepository workspaceRepository,
    required UserRepository userRepository,
    required ActiveWorkspaceChangeUseCase activeWorkspaceChangeUseCase,
  }) : _workspaceRepository = workspaceRepository,
       _userRepository = userRepository,
       _activeWorkspaceChangeUseCase = activeWorkspaceChangeUseCase {
    handleWorkspaceRoleChange = Command0(_handleWorkspaceRoleChange);
    handleRemovalFromWorkspace = Command0(_handleRemovalFromWorkspace);
  }

  final WorkspaceRepository _workspaceRepository;
  final UserRepository _userRepository;
  final ActiveWorkspaceChangeUseCase _activeWorkspaceChangeUseCase;

  late Command0 handleWorkspaceRoleChange;

  /// Returns the workspaceId which to navigate to
  late Command0<String> handleRemovalFromWorkspace;

  Future<Result<void>> _handleWorkspaceRoleChange() async {
    return Future.delayed(const Duration(seconds: 3));
  }

  Future<Result<String>> _handleRemovalFromWorkspace() async {
    return Future.delayed(const Duration(seconds: 3));
  }
}
