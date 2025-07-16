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
    this.workspaceId,
  });

  final RbacPermission permission;
  final Widget child;
  final Widget? fallback;

  /// This field is used only in the app drawer, where we need to check
  /// each permission for each separate workspace.
  final String? workspaceId;

  @override
  Widget build(BuildContext context) {
    return Selector<RbacService, bool>(
      selector: (context, rbacService) {
        final activeWorkspaceId = context
            .read<WorkspaceRepository>()
            .activeWorkspaceId;
        return rbacService.hasPermission(
          permission: permission,
          workspaceId: workspaceId ?? activeWorkspaceId,
        );
      },
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
