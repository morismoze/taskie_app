import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../domain/constants/rbac.dart';
import '../../../domain/use_cases/rbac_use_case.dart';
import '../../../utils/command.dart';

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
    final rbacUseCase = context.read<RbacUseCase>();

    return FutureBuilder(
      future: rbacUseCase.canPerformAction(
        permission: permission,
        workspaceId: workspaceId,
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();

        final hasAccess = (snapshot.data! as Ok<bool?>).value;

        return hasAccess != null && hasAccess ? child : const SizedBox.shrink();
      },
    );
  }
}
