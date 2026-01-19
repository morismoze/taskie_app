import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../core/l10n/l10n_extensions.dart';
import '../../core/ui/action_button_bar.dart';
import '../../core/ui/app_dialog.dart';
import '../../core/ui/app_filled_button.dart';
import '../view_models/goal_details_edit_screen_view_model.dart';

class GoalCloseButton extends StatelessWidget {
  const GoalCloseButton({super.key, required this.viewModel});

  final GoalDetailsEditScreenViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return AppFilledButton(
      onPress: () => _confirmGoalClose(context),
      label: context.localization.goalsDetailsCloseGoal,
      leadingIcon: FontAwesomeIcons.xmark,
      backgroundColor: Theme.of(context).colorScheme.error,
    );
  }

  void _confirmGoalClose(BuildContext context) {
    AppDialog.showAlert(
      context: context,
      canPop: !viewModel.closeGoal.running,
      title: FaIcon(
        FontAwesomeIcons.circleExclamation,
        color: Theme.of(context).colorScheme.error,
        size: 30,
      ),
      content: Text(
        context.localization.goalsDetailsCloseGoalModalMessage,
        style: Theme.of(context).textTheme.bodyMedium,
        textAlign: TextAlign.center,
      ),
      actions: [
        ActionButtonBar.withCommand(
          command: viewModel.closeGoal,
          onSubmit: () => viewModel.closeGoal.execute(),
          onCancel: () => Navigator.of(context).pop(), // Close dialog
          submitButtonText: context.localization.goalsDetailsCloseGoal,
          submitButtonColor: Theme.of(context).colorScheme.error,
        ),
      ],
    );
  }
}
