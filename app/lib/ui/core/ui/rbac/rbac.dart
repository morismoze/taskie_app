import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../data/repositories/user/user_repository.dart';
import '../../../../data/repositories/workspace/workspace_repository.dart';
import '../../../../domain/constants/rbac.dart';
import '../../../../domain/models/user.dart';
import '../../../../utils/command.dart';

class Rbac extends StatelessWidget {
  const Rbac({
    super.key,
    required this.permission,
    required this.child,
    this.fallback,
  });

  final RbacPermission permission;
  final Widget child;
  final Widget? fallback;

  @override
  Widget build(BuildContext context) {
    final userRepository = context.read<UserRepository>();
    final workspaceRepository = context.read<WorkspaceRepository>();

    return FutureBuilder(
      future: Future.wait([
        userRepository.getUser(),
        workspaceRepository.getActiveWorkspaceId(),
      ]),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();

        final userResult = snapshot.data![0];
        final activeWorkspaceIdResult = snapshot.data![1];

        if (userResult is Ok<User> && activeWorkspaceIdResult is Ok<String>) {
          final userRoles = userResult.value.roles;
          final activeWorkspaceId = activeWorkspaceIdResult.value;
          final workspaceRole = userRoles.firstWhere(
            (workspaceRole) => workspaceRole.workspaceId == activeWorkspaceId,
          );

          final hasAccess = RbacConfig.hasPermission(
            workspaceRole.role,
            permission,
          );

          return hasAccess ? child : (fallback ?? const SizedBox.shrink());
        }

        return fallback ?? const SizedBox.shrink();
      },
    );
  }
}
