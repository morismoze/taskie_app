import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../utils/command.dart';
import '../../core/l10n/l10n_extensions.dart';
import '../../core/theme/dimens.dart';
import '../../core/ui/app_snackbar.dart';
import '../../core/ui/blurred_circles_background.dart';
import '../../core/ui/header_bar/header_bar.dart';
import '../../core/ui/or_separator.dart';
import '../view_models/create_workspace_user_screen_viewmodel.dart';
import 'create_virtual_user_form.dart';
import 'workspace_invite_section.dart';

class CreateWorkspaceUserScreen extends StatefulWidget {
  const CreateWorkspaceUserScreen({super.key, required this.viewModel});

  final CreateWorkspaceUserScreenViewModel viewModel;

  @override
  State<StatefulWidget> createState() => _CreateWorkspaceUserScreenState();
}

class _CreateWorkspaceUserScreenState extends State<CreateWorkspaceUserScreen> {
  final TextEditingController _workspaceInviteLinkController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.viewModel.createInviteLink.addListener(_onInviteLinkCreateResult);
    widget.viewModel.createVirtualUser.addListener(_onVirtualUserCreateResult);
  }

  @override
  void didUpdateWidget(covariant CreateWorkspaceUserScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.viewModel.createInviteLink.removeListener(
      _onInviteLinkCreateResult,
    );
    oldWidget.viewModel.createVirtualUser.removeListener(
      _onVirtualUserCreateResult,
    );
    widget.viewModel.createInviteLink.addListener(_onInviteLinkCreateResult);
    widget.viewModel.createVirtualUser.addListener(_onVirtualUserCreateResult);
  }

  @override
  void dispose() {
    widget.viewModel.createInviteLink.removeListener(_onInviteLinkCreateResult);
    widget.viewModel.createInviteLink.removeListener(
      _onVirtualUserCreateResult,
    );
    _workspaceInviteLinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlurredCirclesBackground(
        child: SafeArea(
          child: Column(
            children: [
              HeaderBar(
                title: context.localization.workspaceUsersManagementCreate,
              ),
              SingleChildScrollView(
                padding: EdgeInsets.only(
                  top: Dimens.paddingVertical,
                  left: Dimens.of(context).paddingScreenHorizontal,
                  right: Dimens.of(context).paddingScreenHorizontal,
                  bottom: Dimens.paddingVertical,
                ),
                child: Column(
                  children: [
                    WorkspaceInviteSection(
                      controller: _workspaceInviteLinkController,
                    ),
                    const OrSeparator(),
                    CreateVirtualUserForm(viewModel: widget.viewModel),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onInviteLinkCreateResult() {
    if (widget.viewModel.createInviteLink.completed) {
      final inviteLink =
          (widget.viewModel.createInviteLink.result as Ok<String>).value;
      _workspaceInviteLinkController.text = inviteLink;
      widget.viewModel.createInviteLink.clearResult();
    }

    if (widget.viewModel.createInviteLink.error) {
      widget.viewModel.createInviteLink.clearResult();
      // TODO: do something
    }
  }

  void _onVirtualUserCreateResult() {
    if (widget.viewModel.createVirtualUser.completed) {
      widget.viewModel.createVirtualUser.clearResult();
      AppSnackbar.showSuccess(
        context: context,
        message: context
            .localization
            .workspaceUsersManagementCreateVirtualUserSuccess,
      );
      context.pop();
    }

    if (widget.viewModel.createVirtualUser.error) {
      widget.viewModel.createVirtualUser.clearResult();
      AppSnackbar.showSuccess(
        context: context,
        message:
            context.localization.workspaceUsersManagementCreateVirtualUserError,
      );
    }
  }
}
