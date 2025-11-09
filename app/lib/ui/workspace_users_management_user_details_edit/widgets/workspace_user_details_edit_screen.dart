import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/l10n_extensions.dart';
import '../../core/theme/dimens.dart';
import '../../core/ui/activity_indicator.dart';
import '../../core/ui/app_snackbar.dart';
import '../../core/ui/blurred_circles_background.dart';
import '../../core/ui/header_bar/header_bar.dart';
import '../view_models/workspace_user_details_edit_screen_view_model.dart';
import 'workspace_user_details_edit_form.dart';

class WorkspaceUserDetailsEditScreen extends StatefulWidget {
  const WorkspaceUserDetailsEditScreen({super.key, required this.viewModel});

  final WorkspaceUserDetailsEditScreenViewModel viewModel;

  @override
  State<WorkspaceUserDetailsEditScreen> createState() =>
      _WorkspaceUserDetailsEditScreenState();
}

class _WorkspaceUserDetailsEditScreenState
    extends State<WorkspaceUserDetailsEditScreen> {
  @override
  void initState() {
    widget.viewModel.editWorkspaceUserDetails.addListener(
      _onWorkspaceUserDetailsEditResult,
    );
    super.initState();
  }

  @override
  void didUpdateWidget(covariant WorkspaceUserDetailsEditScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.viewModel.editWorkspaceUserDetails.removeListener(
      _onWorkspaceUserDetailsEditResult,
    );
    widget.viewModel.editWorkspaceUserDetails.addListener(
      _onWorkspaceUserDetailsEditResult,
    );
  }

  @override
  void dispose() {
    widget.viewModel.editWorkspaceUserDetails.removeListener(
      _onWorkspaceUserDetailsEditResult,
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlurredCirclesBackground(
        child: Column(
          children: [
            HeaderBar(
              title:
                  context.localization.workspaceUsersManagementUserDetailsEdit,
            ),
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
                      child: Column(
                        spacing: 30,
                        children: [
                          Text.rich(
                            TextSpan(
                              text: '${context.localization.misc_note}: ',
                              style: Theme.of(context).textTheme.labelMedium!
                                  .copyWith(
                                    fontSize: 13,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold,
                                  ),
                              children: [
                                TextSpan(
                                  text: context
                                      .localization
                                      .workspaceUsersManagementUserDetailsEditNote,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .copyWith(
                                        fontSize: 13,
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.normal,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          WorkspaceUserDetailsEditForm(
                            viewModel: widget.viewModel,
                          ),
                        ],
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

  void _onWorkspaceUserDetailsEditResult() {
    if (widget.viewModel.editWorkspaceUserDetails.completed) {
      widget.viewModel.editWorkspaceUserDetails.clearResult();
      AppSnackbar.showSuccess(
        context: context,
        message:
            context.localization.workspaceUsersManagementUserDetailsEditSuccess,
      );
      context.pop(); // Navigate back to details page
    }

    if (widget.viewModel.editWorkspaceUserDetails.error) {
      widget.viewModel.editWorkspaceUserDetails.clearResult();
      AppSnackbar.showError(
        context: context,
        message:
            context.localization.workspaceUsersManagementUserDetailsEditError,
      );
    }
  }
}
