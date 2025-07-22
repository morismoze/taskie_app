import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../core/l10n/l10n_extensions.dart';
import '../../../core/ui/app_filled_button.dart';
import '../../../core/ui/app_modal.dart';
import '../../../core/ui/app_text_button.dart';
import '../view_models/app_drawer_viewmodel.dart';

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
    AppDialog.show(
      context: context,
      canPop: viewModel.leaveWorkspace.running,
      title: FaIcon(
        FontAwesomeIcons.circleExclamation,
        color: Theme.of(context).colorScheme.error,
        size: 30,
      ),
      message: Text(
        context.localization.appDrawerLeaveWorkspaceModalMessage,
        style: Theme.of(context).textTheme.bodyMedium,
        textAlign: TextAlign.center,
      ),
      actions: [
        ListenableBuilder(
          listenable: viewModel.leaveWorkspace,
          builder: (BuildContext builderContext, _) => AppFilledButton(
            label: builderContext.localization.appDrawerLeaveWorkspaceModalCta,
            onPress: () => viewModel.leaveWorkspace.execute(workspaceId),
            backgroundColor: Theme.of(builderContext).colorScheme.error,
            isLoading: viewModel.leaveWorkspace.running,
          ),
        ),
        ListenableBuilder(
          listenable: viewModel.leaveWorkspace,
          builder: (BuildContext builderContext, _) => AppTextButton(
            disabled: viewModel.leaveWorkspace.running,
            label: builderContext.localization.misc_cancel,
            onPress: () => Navigator.pop(builderContext),
          ),
        ),
      ],
    );
  }
}
