import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../core/l10n/l10n_extensions.dart';
import '../../core/ui/app_dialog.dart';
import '../../core/ui/app_filled_button.dart';
import '../../core/ui/app_text_button.dart';
import '../view_models/workspace_users_management_screen_viewmodel.dart';

class DeleteWorkspaceUserButton extends StatelessWidget {
  const DeleteWorkspaceUserButton({
    super.key,
    required this.viewModel,
    required this.workspaceId,
    required this.workspaceUserId,
  });

  final WorkspaceUsersManagementScreenViewModel viewModel;
  final String workspaceId;
  final String workspaceUserId;

  @override
  Widget build(BuildContext context) {
    return AppTextButton(
      onPress: () => _confirmWorkspaceUserDeletion(context, workspaceId),
      label: context.localization.workspaceUsersManagementDeleteUser,
      leadingIcon: FontAwesomeIcons.userMinus,
      color: Theme.of(context).colorScheme.error,
    );
  }

  void _confirmWorkspaceUserDeletion(BuildContext context, String workspaceId) {
    AppDialog.showAlert(
      context: context,
      canPop: !viewModel.deleteWorkspaceUser.running,
      title: FaIcon(
        FontAwesomeIcons.circleExclamation,
        color: Theme.of(context).colorScheme.error,
        size: 30,
      ),
      content: Text(
        context.localization.workspaceUsersManagementDeleteUserModalMessage,
        style: Theme.of(context).textTheme.bodyMedium,
        textAlign: TextAlign.center,
      ),
      actions: [
        ListenableBuilder(
          listenable: viewModel.deleteWorkspaceUser,
          builder: (BuildContext builderContext, _) => AppFilledButton(
            label: builderContext
                .localization
                .workspaceUsersManagementDeleteUserModalCta,
            onPress: () => viewModel.deleteWorkspaceUser.execute((
              workspaceId,
              workspaceUserId,
            )),
            backgroundColor: Theme.of(builderContext).colorScheme.error,
            loading: viewModel.deleteWorkspaceUser.running,
          ),
        ),
        ListenableBuilder(
          listenable: viewModel.deleteWorkspaceUser,
          builder: (BuildContext builderContext, _) => AppTextButton(
            disabled: viewModel.deleteWorkspaceUser.running,
            label: builderContext.localization.misc_cancel,
            onPress: () => Navigator.pop(builderContext),
          ),
        ),
      ],
    );
  }
}
