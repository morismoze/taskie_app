import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../data/services/api/exceptions/not_found_exception.dart';
import '../../../data/services/api/workspace/workspace_invite/exceptions/workspace_invite_existing_user_exception.dart';
import '../../../data/services/api/workspace/workspace_invite/exceptions/workspace_invite_expired_or_used_exception.dart';
import '../../../routing/routes.dart';
import '../../../utils/command.dart';
import '../../core/l10n/l10n_extensions.dart';
import '../../core/theme/dimens.dart';
import '../../core/ui/app_snackbar.dart';
import '../../core/ui/blurred_circles_background.dart';
import '../../core/ui/header_bar/header_bar.dart';
import '../../core/ui/or_separator.dart';
import '../view_models/create_workspace_screen_viewmodel.dart';
import 'create_workspace_form.dart';
import 'join_workspace_via_invite_form.dart';

class CreateWorkspaceScreen extends StatefulWidget {
  const CreateWorkspaceScreen({super.key, required this.viewModel});

  final CreateWorkspaceScreenViewModel viewModel;

  @override
  State<CreateWorkspaceScreen> createState() => _CreateWorkspaceScreenState();
}

class _CreateWorkspaceScreenState extends State<CreateWorkspaceScreen> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.createWorkspace.addListener(_onWorkspaceCreateResult);
    widget.viewModel.joinWorkspaceViaInviteLink.addListener(
      _onWorkspaceJoinResult,
    );
  }

  @override
  void didUpdateWidget(covariant CreateWorkspaceScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.viewModel.createWorkspace.removeListener(
      _onWorkspaceCreateResult,
    );
    oldWidget.viewModel.joinWorkspaceViaInviteLink.removeListener(
      _onWorkspaceJoinResult,
    );
    widget.viewModel.createWorkspace.addListener(_onWorkspaceCreateResult);
    widget.viewModel.joinWorkspaceViaInviteLink.addListener(
      _onWorkspaceJoinResult,
    );
  }

  @override
  void dispose() {
    widget.viewModel.createWorkspace.removeListener(_onWorkspaceCreateResult);
    widget.viewModel.joinWorkspaceViaInviteLink.removeListener(
      _onWorkspaceJoinResult,
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlurredCirclesBackground(
        child: SafeArea(
          child: Column(
            children: [
              HeaderBar(title: context.localization.workspaceCreate),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(
                    top: Dimens.paddingVertical,
                    left: Dimens.of(context).paddingScreenHorizontal,
                    right: Dimens.of(context).paddingScreenHorizontal,
                    bottom: Dimens.paddingVertical,
                  ),
                  child: Column(
                    spacing: 10,
                    children: [
                      CreateWorkspaceForm(viewModel: widget.viewModel),
                      const OrSeparator(),
                      JoinWorkspaceViaInviteForm(viewModel: widget.viewModel),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onWorkspaceCreateResult() {
    if (widget.viewModel.createWorkspace.completed) {
      final newWorkspaceId =
          (widget.viewModel.createWorkspace.result as Ok<String>).value;
      widget.viewModel.createWorkspace.clearResult();
      AppSnackbar.showSuccess(
        context: context,
        message: context.localization.workspaceCreationSuccess,
      );
      context.go(Routes.tasks(workspaceId: newWorkspaceId));
    }

    if (widget.viewModel.createWorkspace.error) {
      widget.viewModel.createWorkspace.clearResult();
      AppSnackbar.showError(
        context: context,
        message: context.localization.workspaceCreateError,
      );
    }
  }

  void _onWorkspaceJoinResult() {
    if (widget.viewModel.joinWorkspaceViaInviteLink.completed) {
      final newWorkspaceId =
          (widget.viewModel.joinWorkspaceViaInviteLink.result as Ok<String>)
              .value;
      widget.viewModel.joinWorkspaceViaInviteLink.clearResult();
      context.go(Routes.tasks(workspaceId: newWorkspaceId));
    }

    if (widget.viewModel.joinWorkspaceViaInviteLink.error) {
      final errorResult =
          widget.viewModel.joinWorkspaceViaInviteLink.result as Error;
      widget.viewModel.joinWorkspaceViaInviteLink.clearResult();

      switch (errorResult.error) {
        case NotFoundException():
          AppSnackbar.showError(
            context: context,
            message:
                context.localization.workspaceCreateJoinViaInviteLinkNotFound,
          );
          break;
        case WorkspaceInviteExpiredOrUsedException():
          AppSnackbar.showError(
            context: context,
            message: context
                .localization
                .workspaceCreateJoinViaInviteLinkExpiredOrUsed,
          );
          break;
        case WorkspaceInviteExistingUserException():
          AppSnackbar.showError(
            context: context,
            message: context
                .localization
                .workspaceCreateJoinViaInviteLinkExistingUser,
          );
          break;
        default:
          AppSnackbar.showError(
            context: context,
            message: context.localization.misc_somethingWentWrong,
          );
      }
    }
  }
}
