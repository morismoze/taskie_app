import 'package:collection/collection.dart';

import '../../data/repositories/user/user_repository.dart';
import '../../data/repositories/workspace/workspace/workspace_repository.dart';
import '../../utils/command.dart';
import '../constants/rbac.dart';
import '../models/user.dart';

class RbacUseCase {
  RbacUseCase({
    required WorkspaceRepository workspaceRepository,
    required UserRepository userRepository,
  }) : _workspaceRepository = workspaceRepository,
       _userRepository = userRepository;

  final WorkspaceRepository _workspaceRepository;
  final UserRepository _userRepository;

  /// Checks if user has given permission.
  ///
  /// [workspaceId] argument is used only in the app drawer, where we need to check
  /// each permission for each separate workspace.
  Future<Result<bool>> canPerformAction({
    required RbacPermission permission,
    String? workspaceId,
  }) async {
    final userResult = await _userRepository.getUser();
    final activeWorkspaceIdResult = await _workspaceRepository
        .getActiveWorkspaceId();

    if (userResult is Ok<User> && activeWorkspaceIdResult is Ok<String?>) {
      final userRoles = userResult.value.roles;
      final activeWorkspaceId = activeWorkspaceIdResult.value;
      final focusedWorkspaceId = workspaceId ?? activeWorkspaceId;
      final workspaceRole = userRoles.firstWhereOrNull(
        (workspaceRole) => workspaceRole.workspaceId == focusedWorkspaceId,
      );

      if (workspaceRole == null) {
        return const Result.ok(false);
      }

      final hasAccess = RbacConfig.hasPermission(
        workspaceRole.role,
        permission,
      );

      return Result.ok(hasAccess);
    }

    return const Result.ok(false);
  }
}
