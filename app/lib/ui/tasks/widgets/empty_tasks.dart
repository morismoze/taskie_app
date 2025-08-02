import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../routing/routes.dart';
import '../../core/l10n/l10n_extensions.dart';
import '../../core/ui/app_outlined_button.dart';

class EmptyTasks extends StatelessWidget {
  const EmptyTasks({super.key, required this.activeWorkspaceId});

  final String activeWorkspaceId;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        FractionallySizedBox(
          widthFactor: 0.9,
          child: Text(
            context.localization.taskskNoTasks,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        const SizedBox(height: 20),
        AppOutlinedButton(
          label: context.localization.taskCreateNew,
          onPress: () =>
              context.push(Routes.taskCreate(workspaceId: activeWorkspaceId)),
        ),
      ],
    );
  }
}
