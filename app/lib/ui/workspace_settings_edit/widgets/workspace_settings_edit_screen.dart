import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/l10n_extensions.dart';
import '../../core/theme/dimens.dart';
import '../../core/ui/activity_indicator.dart';
import '../../core/ui/app_snackbar.dart';
import '../../core/ui/blurred_circles_background.dart';
import '../../core/ui/header_bar/header_bar.dart';
import '../view_models/workspace_settings_edit_screen_view_model.dart';
import 'workspace_settings_edit_form.dart';

class WorkspaceSettingsEditScreen extends StatefulWidget {
  const WorkspaceSettingsEditScreen({super.key, required this.viewModel});

  final WorkspaceSettingsEditScreenViewModel viewModel;

  @override
  State<WorkspaceSettingsEditScreen> createState() =>
      _WorkspaceSettingsEditScreenState();
}

class _WorkspaceSettingsEditScreenState
    extends State<WorkspaceSettingsEditScreen> {
  @override
  void initState() {
    widget.viewModel.editWorkspaceDetails.addListener(
      _onWorkspaceDetailsEditResult,
    );
    super.initState();
  }

  @override
  void didUpdateWidget(covariant WorkspaceSettingsEditScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.viewModel.editWorkspaceDetails.removeListener(
      _onWorkspaceDetailsEditResult,
    );
    widget.viewModel.editWorkspaceDetails.addListener(
      _onWorkspaceDetailsEditResult,
    );
  }

  @override
  void dispose() {
    widget.viewModel.editWorkspaceDetails.removeListener(
      _onWorkspaceDetailsEditResult,
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlurredCirclesBackground(
        child: Column(
          children: [
            HeaderBar(title: context.localization.workspaceSettingsEdit),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimens.of(context).paddingScreenHorizontal,
                ),
                child: ListenableBuilder(
                  listenable: widget.viewModel,
                  builder: (builderContext, child) {
                    if (widget.viewModel.details == null) {
                      return ActivityIndicator(
                        radius: 16,
                        color: Theme.of(builderContext).colorScheme.primary,
                      );
                    }

                    return SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        vertical: Dimens.of(context).paddingScreenVertical,
                      ),
                      child: WorkspaceSettingsEditForm(
                        viewModel: widget.viewModel,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onWorkspaceDetailsEditResult() {
    if (widget.viewModel.editWorkspaceDetails.completed) {
      widget.viewModel.editWorkspaceDetails.clearResult();
      AppSnackbar.showSuccess(
        context: context,
        message: context.localization.workspaceSettingsEditSuccess,
      );
      context.pop(); // Navigate back to settings page
    }

    if (widget.viewModel.editWorkspaceDetails.error) {
      widget.viewModel.editWorkspaceDetails.clearResult();
      AppSnackbar.showError(
        context: context,
        message: context.localization.workspaceSettingsEditError,
      );
    }
  }
}
