import 'package:flutter/material.dart';

import '../../core/l10n/l10n_extensions.dart';
import '../../core/theme/dimens.dart';
import '../../core/utils/user.dart';
import '../view_models/tasks_screen_viewmodel.dart';
import 'workspace_switcher.dart';

class TasksHeader extends StatelessWidget {
  const TasksHeader({super.key, required this.viewModel});

  final TasksScreenViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    // Dart can infer a local variable is not null after if-statement assertion
    final user = viewModel.user;

    if (user == null) {
      return const SizedBox();
    }

    final fullName = UserUtils.constructFullName(
      firstName: user.firstName,
      lastName: user.lastName,
    );

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: EdgeInsets.only(
          left: Dimens.of(context).paddingScreenHorizontal,
          right: Dimens.of(context).paddingScreenHorizontal,
          top: Dimens.paddingVertical / 2,
          bottom: Dimens.paddingVertical / 2,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.localization.tasksHello,
                  style: Theme.of(
                    context,
                  ).textTheme.labelLarge!.copyWith(fontSize: 14),
                ),
                Text(
                  fullName,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const WorkspaceSwitcher(),
          ],
        ),
      ),
    );
  }
}
