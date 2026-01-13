import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../../routing/routes.dart';
import '../../../core/l10n/l10n_extensions.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/dimens.dart';
import '../../../core/ui/app_modal_bottom_sheet.dart';
import '../../../core/ui/app_modal_bottom_sheet_content_wrapper.dart';
import '../../../core/ui/app_text_button.dart';
import '../view_models/app_drawer_viewmodel.dart';
import 'workspace_image.dart';
import 'workspace_leave_button.dart';

class WorkspaceTile extends StatelessWidget {
  const WorkspaceTile({
    super.key,
    required this.viewModel,
    required this.isActive,
    required this.id,
    required this.name,
    this.pictureUrl,
  });

  final AppDrawerViewModel viewModel;
  final bool isActive;
  final String id;
  final String name;
  final String? pictureUrl;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: InkWell(
        onTap: () {
          if (viewModel.activeWorkspaceId != id) {
            // We want to execute workspace change flow only if the
            // selected workspace is different than the current one.
            viewModel.changeActiveWorkspace.execute(id);
          }
        },
        child: WorkspaceImage(url: pictureUrl, isActive: isActive),
      ),
      trailing: InkWell(
        onTap: () =>
            _onWorkspaceOptionsTap(context, viewModel.activeWorkspaceId, id),
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
        name,
        style: Theme.of(
          context,
        ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  void _onWorkspaceOptionsTap(
    BuildContext context,
    String activeWorkspaceId,
    String workspaceId,
  ) {
    AppModalBottomSheet.show(
      context: context,
      enableDrag: !viewModel.leaveWorkspace.running,
      isDismissable: !viewModel.leaveWorkspace.running,
      child: AppModalBottomSheetContentWrapper(
        title: context.localization.appDrawerWorkspaceOptions,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                WorkspaceImage(url: pictureUrl, size: 50, isActive: isActive),
                const SizedBox(width: 12),
                Flexible(
                  child: Text(
                    name,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: Dimens.paddingVertical / 1.2),
            // Show these two options only if the this workspace
            // is the current active one
            if (activeWorkspaceId == workspaceId) ...[
              AppTextButton(
                onPress: () {
                  context.push(Routes.workspaceSettings(workspaceId: id));
                },
                label: context.localization.appDrawerEditWorkspace,
                leadingIcon: FontAwesomeIcons.pencil,
              ),
              AppTextButton(
                onPress: () {
                  context.push(Routes.workspaceUsers(workspaceId: id));
                },
                label: context.localization.appDrawerManageUsers,
                leadingIcon: FontAwesomeIcons.userGroup,
              ),
            ] else
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  context.localization.appDrawerNotActiveWorkspace,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            WorkspaceLeaveButton(
              viewModel: viewModel,
              workspaceId: workspaceId,
            ),
          ],
        ),
      ),
    );
  }
}
