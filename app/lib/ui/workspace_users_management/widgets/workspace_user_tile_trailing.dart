import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../domain/constants/rbac.dart';
import '../../../domain/models/interfaces/user_interface.dart';
import '../../../domain/models/workspace_user.dart';
import '../../core/l10n/l10n_extensions.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/dimens.dart';
import '../../core/ui/app_avatar.dart';
import '../../core/ui/app_modal_bottom_sheet.dart';
import '../../core/ui/app_modal_bottom_sheet_content_wrapper.dart';
import '../../core/ui/rbac.dart';
import '../../core/ui/role_chip.dart';
import '../view_models/workspace_users_management_screen_view_model.dart';
import 'delete_workspace_user_button.dart';

class WorkspaceUserTileTrailing extends StatelessWidget {
  const WorkspaceUserTileTrailing({
    super.key,
    required this.viewModel,
    required this.workspaceUser,
    required this.isCurrentUser,
  });

  final WorkspaceUsersManagementScreenViewModel viewModel;
  final WorkspaceUser workspaceUser;
  final bool isCurrentUser;

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          RoleChip(role: workspaceUser.role),
          if (!isCurrentUser)
            Rbac(
              permission: RbacPermission.workspaceUsersRemove,
              child: InkWell(
                onTap: () => _userOptionsTap(
                  context,
                  viewModel,
                  workspaceUser,
                  viewModel.activeWorkspaceId,
                ),
                child: Container(
                  // Space between RoleChip and InkWell. Not used as spacing: 10 on Row
                  // because when current user is Member there will be Row[RoleChip,SizedBox.shrink()]
                  // meaning there will whitespace of 10 width because SizedBox.shrink() is still a widget
                  margin: const EdgeInsets.only(left: 10),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimens.paddingHorizontal / 4,
                      vertical: Dimens.paddingVertical / 12,
                    ),
                    child: FaIcon(
                      FontAwesomeIcons.ellipsisVertical,
                      color: AppColors.grey2,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _userOptionsTap(
    BuildContext context,
    WorkspaceUsersManagementScreenViewModel viewModel,
    WorkspaceUser workspaceUser,
    String workspaceId,
  ) {
    AppModalBottomSheet.show(
      context: context,
      enableDrag: !viewModel.deleteWorkspaceUser.running,
      isDismissable: !viewModel.deleteWorkspaceUser.running,
      child: AppModalBottomSheetContentWrapper(
        title: context.localization.workspaceUsersManagementUserOptions,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                AppAvatar(
                  hashString: workspaceUser.id,
                  firstName: workspaceUser.firstName,
                  imageUrl: workspaceUser.profileImageUrl,
                ),
                const SizedBox(width: 12),
                Flexible(
                  child: Text(
                    workspaceUser.fullName,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: Dimens.paddingVertical / 1.2),
            DeleteWorkspaceUserButton(
              viewModel: viewModel,
              workspaceId: workspaceId,
              workspaceUserId: workspaceUser.id,
            ),
          ],
        ),
      ),
    );
  }
}
