import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/models/interfaces/user_interface.dart';
import '../../../routing/routes.dart';
import '../../core/l10n/l10n_extensions.dart';
import '../../core/theme/dimens.dart';
import '../../core/ui/header_bar/app_header_action_button.dart';
import '../view_models/tasks_screen_viewmodel.dart';
import 'workspace_switcher.dart';

class TasksHeader extends StatelessWidget {
  const TasksHeader({super.key, required this.viewModel});

  final TasksScreenViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Dimens.of(context).paddingScreenHorizontal,
          vertical: Dimens.of(context).paddingScreenVertical / 2,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ValueListenableBuilder(
              valueListenable: viewModel.userNotifier,
              builder: (builderContext, userValue, _) {
                if (userValue != null) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        builderContext.localization.tasksHello,
                        style: Theme.of(
                          builderContext,
                        ).textTheme.labelLarge!.copyWith(fontSize: 14),
                      ),
                      Text(
                        userValue.fullName,
                        style: Theme.of(builderContext).textTheme.titleLarge!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            const Spacer(),
            const WorkspaceSwitcher(),
            const SizedBox(width: 8),
            AppHeaderActionButton(
              iconData: FontAwesomeIcons.question,
              onTap: () => context.push(
                Routes.tasksGuide(workspaceId: viewModel.activeWorkspaceId),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
