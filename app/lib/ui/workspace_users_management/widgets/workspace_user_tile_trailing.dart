import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../data/services/api/user/models/response/user_response.dart';
import '../../../domain/constants/rbac.dart';
import '../../core/theme/colors.dart';
import '../../core/ui/app_avatar.dart';
import '../../core/ui/app_modal_bottom_sheet.dart';
import '../../core/ui/rbac.dart';
import '../../core/ui/role_chip.dart';
import '../../core/utils/user.dart';
import '../view_models/workspace_users_management_screen_viewmodel.dart';
import 'delete_workspace_user_button.dart';

class WorkspaceUserTileTrailing extends StatelessWidget {
  const WorkspaceUserTileTrailing({
    super.key,
    required this.viewModel,
    required this.workspaceUserId,
    required this.role,
    required this.firstName,
    required this.lastName,
    required this.isCurrentUser,
    this.profileImageUrl,
  });

  final WorkspaceUsersManagementScreenViewModel viewModel;
  final String workspaceUserId;
  final WorkspaceRole role;
  final String firstName;
  final String lastName;
  final bool isCurrentUser;
  final String? profileImageUrl;

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        spacing: 10,
        children: [
          RoleChip(role: role),
          if (!isCurrentUser)
            Rbac(
              permission: RbacPermission.workspaceUsersRemove,
              child: InkWell(
                onTap: () => _userOptionsTap(
                  context,
                  viewModel,
                  firstName,
                  lastName,
                  viewModel.activeWorkspaceId,
                  workspaceUserId,
                  profileImageUrl,
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  child: FaIcon(
                    FontAwesomeIcons.ellipsisVertical,
                    color: AppColors.grey2,
                    size: 20,
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
    String firstName,
    String lastName,
    String workspaceId,
    String workspaceUserId,
    String? profileImageUrl,
  ) {
    final fullName = UserUtils.constructFullName(
      firstName: firstName,
      lastName: lastName,
    );
    AppModalBottomSheet.show(
      context: context,
      enableDrag: !viewModel.deleteWorkspaceUser.running,
      isDismissable: !viewModel.deleteWorkspaceUser.running,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              AppAvatar(
                hashString: workspaceUserId,
                firstName: firstName,
                imageUrl: profileImageUrl,
              ),
              const SizedBox(width: 12),
              Flexible(
                child: Text(
                  fullName,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          DeleteWorkspaceUserButton(
            viewModel: viewModel,
            workspaceId: workspaceId,
            workspaceUserId: workspaceUserId,
          ),
        ],
      ),
    );
  }
}
