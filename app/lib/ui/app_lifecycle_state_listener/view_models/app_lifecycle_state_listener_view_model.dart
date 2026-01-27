import 'package:collection/collection.dart';

import '../../../data/repositories/user/user_repository.dart';
import '../../../data/repositories/workspace/workspace/workspace_repository.dart';
import '../../../data/services/local/auth_event_bus.dart';
import '../../../utils/command.dart';

sealed class CheckUserResult {
  const CheckUserResult();
}

class CheckUserResultRemovedFromWorkspace extends CheckUserResult {
  const CheckUserResultRemovedFromWorkspace();
}

class CheckUserResultChangedRole extends CheckUserResult {
  const CheckUserResultChangedRole();
}

class AppLifecycleStateListenerViewModel {
  AppLifecycleStateListenerViewModel({
    required UserRepository userRepository,
    required WorkspaceRepository workspaceRepository,
    required AuthEventBus authEventBus,
  }) : _userRepository = userRepository,
       _workspaceRepository = workspaceRepository,
       _authEventBus = authEventBus {
    checkUser = Command0(_checkUser);
  }

  final UserRepository _userRepository;
  final WorkspaceRepository _workspaceRepository;
  final AuthEventBus _authEventBus;

  /// Re-fetch of the most important data: user and user's workspaces.
  ///
  /// Returns bool record: first bool defines if user is still part of
  /// the active workspace; second bool represents if the user still
  /// has the same role in the active workspace.
  late Command0<CheckUserResult?> checkUser;

  static const _minInterval = Duration(seconds: 2);
  DateTime? _lastRunAt;

  void onAppResumed() {
    if (checkUser.running) return;

    final now = DateTime.now();
    if (_lastRunAt != null && now.difference(_lastRunAt!) < _minInterval) {
      return;
    }

    _lastRunAt = now;
    checkUser.execute();
  }

  Future<Result<CheckUserResult?>> _checkUser() async {
    final previousUser = _userRepository.user;

    // 0. Early return if user is not set. This can happen
    // in case of sign in as Google opens up external activity
    // window in which user picks the account, and then Google
    // closes the window, app gets resumed, and tries to invoke
    // this. But actual login to our API is not yet finished
    // and this will fail with auth error.
    if (previousUser == null) {
      return const Result.ok(null);
    }

    // 1. Load user
    final resultLoadUser = await _userRepository.loadUser().last;

    switch (resultLoadUser) {
      case Ok():
        break;
      case Error():
        return Result.error(resultLoadUser.error);
    }

    // 2. Load workspaces
    final resultLoadWorkspaces = await _workspaceRepository
        .loadWorkspaces()
        .last;

    switch (resultLoadWorkspaces) {
      case Ok():
        break;
      case Error():
        return Result.error(resultLoadWorkspaces.error);
    }

    // 3.a Load active workspace IDs
    final activeWorkspaceIdResult = await _workspaceRepository
        .loadActiveWorkspaceId();

    switch (activeWorkspaceIdResult) {
      case Ok():
        final activeWorkspaceId = activeWorkspaceIdResult.value;

        if (activeWorkspaceId == null) {
          return const Result.ok(null);
        }

        final currentActiveWorkspace = resultLoadWorkspaces.value
            .firstWhereOrNull((workspace) => workspace.id == activeWorkspaceId);

        if (currentActiveWorkspace != null) {
          final previousUserRole = previousUser.roles.firstWhereOrNull(
            (role) => role.workspaceId == activeWorkspaceId,
          );

          if (previousUserRole == null) {
            return const Result.ok(null);
          }

          final stillHasTheSameRoleInTheActiveWorkspace =
              _userRepository.user?.roles.firstWhereOrNull(
                (role) =>
                    role.workspaceId == activeWorkspaceId &&
                    role.role == previousUserRole.role,
              ) !=
              null;

          return Result.ok(
            stillHasTheSameRoleInTheActiveWorkspace
                ? null
                : const CheckUserResultChangedRole(),
          );
        } else {
          return const Result.ok(CheckUserResultRemovedFromWorkspace());
        }
      case Error():
        return Result.error(activeWorkspaceIdResult.error);
    }
  }

  void emitRemovedfromWorkspaceEvent() {
    _authEventBus.emit(UserRemovedFromWorkspaceEvent());
  }

  void emitChangedRoleEvent() {
    _authEventBus.emit(UserRoleChangedEvent());
  }
}
