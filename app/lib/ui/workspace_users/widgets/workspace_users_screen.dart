import 'package:flutter/material.dart';

import '../../core/l10n/l10n_extensions.dart';
import '../../core/ui/app_snackbar.dart';
import '../../core/ui/blurred_circles_background.dart';
import '../view_models/workspace_users_viewmodel.dart';

class WorkspaceUsersScreen extends StatefulWidget {
  const WorkspaceUsersScreen({super.key, required this.viewModel});

  final WorkspaceUsersViewModel viewModel;

  @override
  State<StatefulWidget> createState() => _WorkspaceUsersScreenState();
}

class _WorkspaceUsersScreenState extends State<WorkspaceUsersScreen> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.createInviteLink.addListener(_onResult);
  }

  @override
  void didUpdateWidget(covariant WorkspaceUsersScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.viewModel.createInviteLink.removeListener(_onResult);
    widget.viewModel.createInviteLink.addListener(_onResult);
  }

  @override
  void dispose() {
    widget.viewModel.createInviteLink.removeListener(_onResult);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SizedBox.expand(
        child: BlurredCirclesBackground(
          child: SafeArea(child: Text('workspaces users')),
        ),
      ),
    );
  }

  void _onResult() {
    if (widget.viewModel.createInviteLink.completed) {
      widget.viewModel.createInviteLink.clearResult();
    }

    if (widget.viewModel.createInviteLink.error) {
      widget.viewModel.createInviteLink.clearResult();
      AppSnackbar.showError(
        context: context,
        message: context.localization.errorWhileCreatingWorkspace,
      );
    }
  }
}
