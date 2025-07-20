import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

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
    widget.viewModel.createWorkspaceInviteLink.addListener(
      _onInviteLinkCreateResult,
    );
    widget.viewModel.shareWorkspaceInviteLink.addListener(
      _onInviteLinkShareResult,
    );
    widget.viewModel.createVirtualUser.addListener(_onVirtualUserCreateResult);
  }

  @override
  void didUpdateWidget(covariant CreateWorkspaceUserScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.viewModel.createWorkspaceInviteLink.removeListener(
      _onInviteLinkCreateResult,
    );
    oldWidget.viewModel.shareWorkspaceInviteLink.removeListener(
      _onInviteLinkShareResult,
    );
    oldWidget.viewModel.createVirtualUser.removeListener(
      _onVirtualUserCreateResult,
    );
    widget.viewModel.createWorkspaceInviteLink.addListener(
      _onInviteLinkCreateResult,
    );
    widget.viewModel.shareWorkspaceInviteLink.addListener(
      _onInviteLinkShareResult,
    );
    widget.viewModel.createVirtualUser.addListener(_onVirtualUserCreateResult);
  }

  @override
  void dispose() {
    widget.viewModel.createWorkspaceInviteLink.removeListener(
      _onInviteLinkCreateResult,
    );
    widget.viewModel.shareWorkspaceInviteLink.removeListener(
      _onInviteLinkShareResult,
    );
    widget.viewModel.createVirtualUser.removeListener(
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
                      WorkspaceInviteSection(
                        viewModel: widget.viewModel,
                        controller: _workspaceInviteLinkController,
                      ),
                      const OrSeparator(),
                      CreateVirtualUserForm(viewModel: widget.viewModel),
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

  void _onInviteLinkCreateResult() {
    if (widget.viewModel.createWorkspaceInviteLink.completed) {
      final inviteLink =
          (widget.viewModel.createWorkspaceInviteLink.result as Ok<String>)
              .value;
      _workspaceInviteLinkController.text = inviteLink;
      widget.viewModel.createWorkspaceInviteLink.clearResult();
    }

    if (widget.viewModel.createWorkspaceInviteLink.error) {
      widget.viewModel.createWorkspaceInviteLink.clearResult();
      // TODO: do something
    }
  }

  void _onInviteLinkShareResult() {
    if (widget.viewModel.shareWorkspaceInviteLink.completed) {
      final shareResult =
          (widget.viewModel.shareWorkspaceInviteLink.result as Ok<ShareResult>)
              .value;
      widget.viewModel.shareWorkspaceInviteLink.clearResult();
      print('ALOO ${shareResult.status}');

      // Only re-fetch new workspace invite link if the
      // invite was shared successfully
      if (shareResult.status == ShareResultStatus.success) {
        widget.viewModel.createWorkspaceInviteLink.execute(true);
      }
    }

    if (widget.viewModel.shareWorkspaceInviteLink.error) {
      widget.viewModel.shareWorkspaceInviteLink.clearResult();
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
