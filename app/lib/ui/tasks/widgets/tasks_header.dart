import 'package:flutter/material.dart';

import '../../core/l10n/l10n_extensions.dart';
import '../../core/theme/dimens.dart';
import '../../core/ui/app_avatar.dart';
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

    final firstNameFirstLetter = user.firstName[0];
    final fullName = '${user.firstName} ${user.lastName}';

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: Dimens.of(context).paddingScreenVertical,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              AppAvatar(
                text: firstNameFirstLetter,
                imageUrl: user.profileImageUrl,
              ),
              const SizedBox(width: 13),
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
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ],
              ),
            ],
          ),
          const WorkspaceSwitcher(),
        ],
      ),
    );
  }
}
