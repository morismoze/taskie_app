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
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Dimens.of(context).paddingScreenHorizontal,
          vertical: Dimens.of(context).paddingScreenVertical / 2,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ValueListenableBuilder(
              valueListenable: viewModel.userNotifier,
              builder: (builderContext, userValue, _) {
                if (userValue != null) {
                  final fullName = UserUtils.constructFullName(
                    firstName: userValue.firstName,
                    lastName: userValue.lastName,
                  );

                  return Column(
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
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            const WorkspaceSwitcher(),
          ],
        ),
      ),
    );
  }
}
