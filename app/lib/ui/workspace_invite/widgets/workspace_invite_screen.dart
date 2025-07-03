import 'package:flutter/material.dart';

import '../../core/l10n/l10n_extensions.dart';
import '../../core/ui/app_snackbar.dart';
import '../../core/ui/blurred_circles_background.dart';
import '../view_models/workspace_invite_viewmodel.dart';

class WorkspaceInviteScreen extends StatefulWidget {
  const WorkspaceInviteScreen({super.key, required this.viewModel});

  final WorkspaceInviteViewModel viewModel;

  @override
  State<StatefulWidget> createState() => _WorkspaceInviteScreenState();
}

class _WorkspaceInviteScreenState extends State<WorkspaceInviteScreen> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.createInviteLink.addListener(_onResult);
  }

  @override
  void didUpdateWidget(covariant WorkspaceInviteScreen oldWidget) {
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
          child: SafeArea(child: Text('workspace invite')),
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
