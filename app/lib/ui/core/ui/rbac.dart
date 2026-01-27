import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/repositories/workspace/workspace/workspace_repository.dart';
import '../../../domain/constants/rbac.dart';
import '../services/rbac_service.dart';

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
    final activeWorkspaceId = context
        .read<WorkspaceRepository>()
        .activeWorkspaceId;

    if (activeWorkspaceId == null) {
      return const SizedBox.shrink();
    }

    return Selector<RbacService, bool>(
      selector: (_, rbacService) => rbacService.hasPermission(
        permission: permission,
        workspaceId: activeWorkspaceId,
      ),
      builder: (context, hasAccess, _) {
        if (hasAccess) {
          return child;
        } else {
          return fallback ?? const SizedBox.shrink();
        }
      },
    );
  }
}
