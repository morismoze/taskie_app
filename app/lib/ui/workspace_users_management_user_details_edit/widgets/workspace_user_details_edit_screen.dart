import 'package:flutter/material.dart';

import '../../core/l10n/l10n_extensions.dart';
import '../../core/theme/dimens.dart';
import '../../core/ui/activity_indicator.dart';
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
    super.initState();
    widget.viewModel.editWorkspaceUserDetails.addListener(
      _onWorkspaceUserDetailsEditResult,
    );
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
                padding: EdgeInsets.only(
                  left: Dimens.of(context).paddingScreenHorizontal,
                  right: Dimens.of(context).paddingScreenHorizontal,
                  bottom: Dimens.paddingVertical,
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

                    return child!;
                  },
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(top: Dimens.paddingVertical),
                    child: Column(
                      spacing: 30,
                      children: [
                        Text.rich(
                          TextSpan(
                            text: '${context.localization.note}: ',
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
                                style: Theme.of(context).textTheme.labelMedium!
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
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onWorkspaceUserDetailsEditResult() {}
}

class _LabeledData extends StatelessWidget {
  const _LabeledData({
    super.key,
    required this.label,
    required this.data,
    this.leading,
  });

  final String label;
  final String data;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 8,
      children: [
        Text(
          '$label: ',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (leading != null) ...[leading!, const SizedBox(width: 8)],
            Text(
              data,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ],
    );
  }
}
