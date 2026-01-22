import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../core/l10n/l10n_extensions.dart';
import '../../core/ui/action_button_bar.dart';
import '../../core/ui/app_dialog.dart';
import '../../core/ui/app_filled_button.dart';
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
    // Try to unfocus a field on the details edit form if any field was focused.
    // Try to unfocus last focused field from the details edit form
    // FocusScope does not work as it tried find up in the widget
    // tree, but TaskCloseButton and TaskDetailsEditForm are on the
    // same level.
    FocusManager.instance.primaryFocus?.unfocus();

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
        ActionButtonBar.withCommand(
          command: viewModel.closeTask,
          onSubmit: () => viewModel.closeTask.execute(),
          onCancel: () => Navigator.of(context).pop(), // Close dialog,
          submitButtonText: context.localization.tasksDetailsCloseTask,
          submitButtonColor: Theme.of(context).colorScheme.error,
        ),
      ],
    );
  }
}
