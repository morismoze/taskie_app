import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../../utils/command.dart';
import '../../../data/repositories/auth/exceptions/refresh_token_failed_exception.dart';
import '../../../routing/routes.dart';
import '../../core/l10n/l10n_extensions.dart';
import '../../core/theme/colors.dart';
import '../../core/ui/app_filled_button.dart';
import '../../core/ui/app_modal.dart';
import '../../core/ui/app_modal_bottom_sheet.dart';
import '../../core/ui/app_snackbar.dart';
import '../../core/ui/app_text_button.dart';
import '../view_models/app_drawer_viewmodel.dart';
import 'workspace_image.dart';

class WorkspaceTile extends StatefulWidget {
  const WorkspaceTile({
    super.key,
    required this.id,
    required this.name,
    required this.viewModel,
    required this.isActive,
    this.pictureUrl,
  });

  final String id;
  final String name;
  final AppDrawerViewModel viewModel;
  final bool isActive;
  final String? pictureUrl;

  @override
  State<WorkspaceTile> createState() => _WorkspaceTileState();
}

class _WorkspaceTileState extends State<WorkspaceTile> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.leaveWorkspace.addListener(_onResult);
  }

  @override
  void didUpdateWidget(covariant WorkspaceTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.viewModel.leaveWorkspace.removeListener(_onResult);
    widget.viewModel.leaveWorkspace.addListener(_onResult);
  }

  @override
  void dispose() {
    widget.viewModel.leaveWorkspace.removeListener(_onResult);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.all(0),
      leading: InkWell(
        splashFactory: NoSplash.splashFactory,
        onTap: () => widget.viewModel.setActiveWorkspace.execute(widget.id),
        child: WorkspaceImage(
          url: widget.pictureUrl,
          isActive: widget.isActive,
        ),
      ),
      trailing: InkWell(
        splashFactory: NoSplash.splashFactory,
        onTap: () => _onWorkspaceOptionsTap(context, widget.id),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          child: FaIcon(
            FontAwesomeIcons.ellipsisVertical,
            color: AppColors.grey2,
            size: 20,
          ),
        ),
      ),
      title: Text(
        widget.name,
        style: Theme.of(
          context,
        ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  void _onWorkspaceOptionsTap(BuildContext context, String workspaceId) {
    AppModalBottomSheet.show(
      context: context,
      enableDrag: !widget.viewModel.leaveWorkspace.running,
      isDismissable: !widget.viewModel.leaveWorkspace.running,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              WorkspaceImage(
                url: widget.pictureUrl,
                size: 50,
                isActive: widget.isActive,
              ),
              const SizedBox(width: 12),
              Flexible(
                child: Text(
                  widget.name,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          AppTextButton(
            onPress: () {
              Navigator.of(context).pop(); // Close bottom sheet
              Navigator.of(context).pop(); // Close drawer
              context.push(Routes.workspaceSettings(widget.id));
            },
            label: context.localization.appDrawerEditWorkspace,
            leadingIcon: FontAwesomeIcons.pencil,
          ),
          AppTextButton(
            onPress: () {
              Navigator.of(context).pop(); // Close bottom sheet
              Navigator.of(context).pop(); // Close drawer
              context.push(Routes.workspaceInvite(widget.id));
            },
            label: context.localization.appDrawerInviteMembers,
            leadingIcon: FontAwesomeIcons.userPlus,
          ),
          AppTextButton(
            onPress: () => _confirmWorkspaceLeave(context, workspaceId),
            label: context.localization.appDrawerLeaveWorkspace,
            leadingIcon: FontAwesomeIcons.arrowRightFromBracket,
            color: Theme.of(context).colorScheme.error,
          ),
        ],
      ),
    );
  }

  void _confirmWorkspaceLeave(BuildContext context, String workspaceId) {
    AppModal.show(
      context: context,
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
      ctaButton: ListenableBuilder(
        listenable: widget.viewModel.leaveWorkspace,
        builder: (_, _) => AppFilledButton(
          label: context.localization.appDrawerLeaveWorkspaceModalCta,
          onPress: () => widget.viewModel.leaveWorkspace.execute(workspaceId),
          backgroundColor: Theme.of(context).colorScheme.error,
          isLoading: widget.viewModel.leaveWorkspace.running,
        ),
      ),
      cancelButton: AppTextButton(
        label: context.localization.cancel,
        onPress: () => Navigator.pop(context),
      ),
    );
  }

  void _onResult() {
    if (widget.viewModel.leaveWorkspace.completed) {
      widget.viewModel.leaveWorkspace.clearResult();
      Navigator.of(context).pop(); // Close modal
      Navigator.of(context).pop(); // Close bottom sheet
      AppSnackbar.showSuccess(
        context: context,
        message: context.localization.appDrawerLeaveWorkspaceSuccess(
          widget.name,
        ),
      );
    }

    if (widget.viewModel.leaveWorkspace.error) {
      final errorResult = widget.viewModel.leaveWorkspace.result as Error;

      switch (errorResult.error) {
        case RefreshTokenFailedException():
          Navigator.of(context).pop(); // Close modal
          AppSnackbar.showError(
            context: context,
            message: context.localization.appDrawerLeaveWorkspaceError,
          );
          context.go(Routes.login);
          break;
        default:
          Navigator.of(context).pop(); // Close modal
          AppSnackbar.showError(
            context: context,
            message: context.localization.appDrawerLeaveWorkspaceError,
          );
      }

      widget.viewModel.leaveWorkspace.clearResult();
    }
  }
}
