import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../core/l10n/l10n_extensions.dart';
import '../../../core/ui/action_button_bar.dart';
import '../../../core/ui/app_dialog.dart';
import '../../../core/ui/app_text_button.dart';
import '../../../core/utils/extensions.dart';
import '../view_models/app_drawer_view_model.dart';

class WorkspaceLeaveButton extends StatelessWidget {
  const WorkspaceLeaveButton({
    super.key,
    required this.viewModel,
    required this.workspaceId,
  });

  final AppDrawerViewModel viewModel;
  final String workspaceId;

  @override
  Widget build(BuildContext context) {
    return AppTextButton(
      onPress: () => _confirmWorkspaceLeave(context, workspaceId),
      label: context.localization.appDrawerLeaveWorkspace,
      leadingIcon: FontAwesomeIcons.arrowRightFromBracket,
      color: Theme.of(context).colorScheme.error,
    );
  }

  void _confirmWorkspaceLeave(BuildContext context, String workspaceId) {
    AppDialog.showAlert(
      context: context,
      canPop: !viewModel.leaveWorkspace.running,
      title: FaIcon(
        FontAwesomeIcons.circleExclamation,
        color: Theme.of(context).colorScheme.error,
        size: 30,
      ),
      content: context.localization.appDrawerLeaveWorkspaceModalMessage
          .toStyledText(
            style: Theme.of(context).textTheme.bodyMedium!,
            textAlign: TextAlign.center,
          ),
      actions: [
        ActionButtonBar.withCommand(
          command: viewModel.leaveWorkspace,
          onSubmit: () => viewModel.leaveWorkspace.execute(workspaceId),
          onCancel: () =>
              Navigator.of(context, rootNavigator: true).pop(), // Close dialog
          submitButtonText:
              context.localization.appDrawerLeaveWorkspaceModalCta,
          submitButtonColor: Theme.of(context).colorScheme.error,
        ),
      ],
    );
  }
}
