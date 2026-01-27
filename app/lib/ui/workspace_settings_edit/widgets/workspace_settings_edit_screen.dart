import 'package:flutter/material.dart';

import '../../core/l10n/l10n_extensions.dart';
import '../../core/theme/dimens.dart';
import '../../core/ui/activity_indicator.dart';
import '../../core/ui/app_toast.dart';
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
    super.initState();
    widget.viewModel.editWorkspaceDetails.addListener(
      _onWorkspaceDetailsEditResult,
    );
  }

  @override
  void didUpdateWidget(covariant WorkspaceSettingsEditScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.viewModel.editWorkspaceDetails !=
        oldWidget.viewModel.editWorkspaceDetails) {
      oldWidget.viewModel.editWorkspaceDetails.removeListener(
        _onWorkspaceDetailsEditResult,
      );
      widget.viewModel.editWorkspaceDetails.addListener(
        _onWorkspaceDetailsEditResult,
      );
    }
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
                      return const ActivityIndicator(radius: 16);
                    }

                    return SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
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
      AppToast.showSuccess(
        context: context,
        message: context.localization.workspaceSettingsEditSuccess,
      );
    }

    if (widget.viewModel.editWorkspaceDetails.error) {
      widget.viewModel.editWorkspaceDetails.clearResult();
      AppToast.showError(
        context: context,
        message: context.localization.workspaceSettingsEditError,
      );
    }
  }
}
