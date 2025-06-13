import 'package:flutter/material.dart';

import '../../core/theme/dimens.dart';
import '../../core/ui/app_avatar.dart';
import '../../core/util/color.dart';
import '../view_models/tasks_viewmodel.dart';

class TasksHeader extends StatelessWidget {
  const TasksHeader({super.key, required this.viewModel});

  final TasksViewModel viewModel;

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
      padding: EdgeInsets.only(
        left: Dimens.of(context).paddingScreenHorizontal,
        right: Dimens.of(context).paddingScreenHorizontal,
        top: Dimens.of(context).paddingScreenVertical,
        bottom: Dimens.paddingVertical,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppAvatar(
            text: firstNameFirstLetter,
            backgroundColor: ColorGenerator.generateColorFromString(fullName),
            imageUrl: user.profileImageUrl,
          ),
          const Text('Add task'),
        ],
      ),
    );
  }
}
