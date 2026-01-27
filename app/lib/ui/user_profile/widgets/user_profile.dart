import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../data/services/api/api_response.dart';
import '../../../data/services/api/exceptions/general_api_exception.dart';
import '../../../domain/models/interfaces/user_interface.dart';
import '../../../routing/routes.dart';
import '../../../utils/command.dart';
import '../../core/l10n/l10n_extensions.dart';
import '../../core/theme/dimens.dart';
import '../../core/ui/action_button_bar.dart';
import '../../core/ui/activity_indicator.dart';
import '../../core/ui/app_avatar.dart';
import '../../core/ui/app_dialog.dart';
import '../../core/ui/app_filled_button.dart';
import '../../core/ui/app_toast.dart';
import '../../core/ui/role_chip.dart';
import '../../core/ui/separator.dart';
import '../../core/utils/extensions.dart';
import '../view_models/user_profile_view_model.dart';
import 'user_profile_button.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key, required this.viewModel});

  final UserProfileViewModel viewModel;

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.signOut.addListener(_onSignOutResult);
    widget.viewModel.deleteAccount.addListener(_onAccountDeleteResult);
  }

  @override
  void didUpdateWidget(covariant UserProfile oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.viewModel != oldWidget.viewModel) {
      oldWidget.viewModel.signOut.removeListener(_onSignOutResult);
      oldWidget.viewModel.deleteAccount.removeListener(_onAccountDeleteResult);

      widget.viewModel.signOut.addListener(_onSignOutResult);
      widget.viewModel.deleteAccount.addListener(_onAccountDeleteResult);
    }
  }

  @override
  void dispose() {
    widget.viewModel.signOut.removeListener(_onSignOutResult);
    widget.viewModel.deleteAccount.removeListener(_onAccountDeleteResult);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([
        widget.viewModel.loadUserDetails,
        widget.viewModel.signOut,
        widget.viewModel,
      ]),
      builder: (builderContext, _) {
        final details = widget.viewModel.details;

        if (details == null) {
          return const ActivityIndicator(radius: 16);
        }

        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Dimens.paddingHorizontal,
          ),
          child: Column(
            children: [
              Row(
                spacing: Dimens.paddingHorizontal / 1.5,
                children: [
                  AppAvatar(
                    hashString: details.id,
                    firstName: details.firstName,
                    imageUrl: details.profileImageUrl,
                    size: 60,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        details.fullName,
                        style: Theme.of(builderContext).textTheme.titleLarge!
                            .copyWith(fontWeight: FontWeight.bold, height: 1),
                      ),
                      if (widget.viewModel.currentWorkspaceRole != null)
                        // Flutter Chip for some reason has vertical padding even though
                        // it is set to 0 in RoleChip impl.
                        RoleChip(role: widget.viewModel.currentWorkspaceRole!),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: Dimens.paddingVertical),
              UserProfileButton(
                onPress: () {
                  context.push(Routes.preferences);
                },
                text: context.localization.preferencesLabel,
                icon: FontAwesomeIcons.gear,
              ),
              UserProfileButton(
                onPress: () {
                  widget.viewModel.signOut.execute();
                },
                text: context.localization.signOut,
                icon: FontAwesomeIcons.arrowRightFromBracket,
                isLoading: widget.viewModel.signOut.running,
              ),
              const SizedBox(height: Dimens.paddingVertical / 1.2),
              const Separator(),
              const SizedBox(height: Dimens.paddingVertical / 1.2),
              UserProfileButton(
                onPress: _showAccountDeletionConfirmationDialog,
                text: context.localization.deleteAccount,
                icon: FontAwesomeIcons.trash,
                isLoading: widget.viewModel.deleteAccount.running,
                isDanger: true,
              ),
            ],
          ),
        );
      },
    );
  }

  void _onSignOutResult() {
    if (widget.viewModel.signOut.completed) {
      widget.viewModel.signOut.clearResult();
    }

    if (widget.viewModel.signOut.error) {
      widget.viewModel.signOut.clearResult();
      AppToast.showError(
        context: context,
        message: context.localization.signOutError,
      );
    }
  }

  void _onAccountDeleteResult() {
    if (widget.viewModel.deleteAccount.completed) {
      AppToast.showSuccess(
        context: context,
        message: context.localization.deleteAccountSuccess,
      );
      widget.viewModel.signOut.clearResult();
    }

    if (widget.viewModel.deleteAccount.error) {
      final errorResult = widget.viewModel.deleteAccount.result as Error;
      widget.viewModel.deleteAccount.clearResult();
      switch (errorResult.error) {
        case GeneralApiException(error: final apiError)
            when apiError.code == ApiErrorCode.soleManagerConflict:
          Navigator.of(context, rootNavigator: true).pop(); // Close dialog
          _showSoleManagerConflictDialog();
          break;
        default:
          AppToast.showError(
            context: context,
            message: context.localization.tasksAddTaskAssignmentError,
          );
      }
    }
  }

  void _showAccountDeletionConfirmationDialog() {
    AppDialog.showAlert(
      context: context,
      canPop: false,
      title: FaIcon(
        FontAwesomeIcons.circleExclamation,
        color: Theme.of(context).colorScheme.error,
        size: 30,
      ),
      content: context.localization.deleteAccountText.toStyledText(
        style: Theme.of(context).textTheme.bodyMedium!,
      ),
      actions: [
        ActionButtonBar.withCommand(
          command: widget.viewModel.deleteAccount,
          onSubmit: () => widget.viewModel.deleteAccount.execute(),
          onCancel: () =>
              Navigator.of(context, rootNavigator: true).pop(), // Close dialog
          submitButtonText: context.localization.deleteAccountConfirmButton,
          submitButtonColor: Theme.of(context).colorScheme.error,
        ),
      ],
    );
  }

  void _showSoleManagerConflictDialog() {
    AppDialog.show(
      context: context,
      canPop: false,
      title: FaIcon(
        FontAwesomeIcons.circleInfo,
        color: Theme.of(context).colorScheme.primary,
        size: 30,
      ),
      content: Text(
        context.localization.deleteAccountSoleManagerConflict,
        style: Theme.of(context).textTheme.bodyMedium,
        textAlign: TextAlign.center,
      ),
      actions: AppFilledButton(
        label: context.localization.misc_ok,
        onPress: () {
          Navigator.of(context, rootNavigator: true).pop(); // Close dialog
        },
      ),
    );
  }
}
