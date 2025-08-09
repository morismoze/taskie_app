import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../core/l10n/l10n_extensions.dart';
import '../../core/ui/app_dialog.dart';
import '../../core/ui/app_filled_button.dart';
import '../../core/ui/app_text_button.dart';
import '../view_models/task_details_edit_screen_view_model.dart';

class TaskCloseButton extends StatelessWidget {
  const TaskCloseButton({super.key, required this.viewModel});

  final TaskDetailsEditScreenViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return AppFilledButton(
      onPress: () => _confirmTaskClose(context),
      label: context.localization.tasksDetailsCloseTask,
      leadingIcon: FontAwesomeIcons.xmark,
      backgroundColor: Theme.of(context).colorScheme.error,
    );
  }

  void _confirmTaskClose(BuildContext context) {
    AppDialog.showAlert(
      context: context,
      canPop: !viewModel.closeTask.running,
      title: FaIcon(
        FontAwesomeIcons.circleExclamation,
        color: Theme.of(context).colorScheme.error,
        size: 30,
      ),
      content: Text(
        context.localization.tasksDetailsCloseTaskModalMessage,
        style: Theme.of(context).textTheme.bodyMedium,
        textAlign: TextAlign.center,
      ),
      actions: [
        ListenableBuilder(
          listenable: viewModel.closeTask,
          builder: (BuildContext builderContext, _) => AppFilledButton(
            label: builderContext.localization.tasksDetailsCloseTask,
            onPress: () => viewModel.closeTask.execute(),
            backgroundColor: Theme.of(builderContext).colorScheme.error,
            loading: viewModel.closeTask.running,
          ),
        ),
        ListenableBuilder(
          listenable: viewModel.closeTask,
          builder: (BuildContext builderContext, _) => AppTextButton(
            disabled: viewModel.closeTask.running,
            label: builderContext.localization.misc_cancel,
            onPress: () => Navigator.pop(builderContext),
          ),
        ),
      ],
    );
  }
}
