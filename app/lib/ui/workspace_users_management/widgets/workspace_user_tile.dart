import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/models/interfaces/user_interface.dart';
import '../../../domain/models/workspace_user.dart';
import '../../../routing/routes.dart';
import '../../core/ui/app_avatar.dart';
import '../../core/ui/card_container.dart';
import '../view_models/workspace_users_management_screen_viewmodel.dart';
import 'workspace_user_tile_trailing.dart';

class WorkspaceUserTile extends StatelessWidget {
  const WorkspaceUserTile({
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
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => context.push(
        Routes.workspaceUsersWithId(
          workspaceId: viewModel.activeWorkspaceId,
          workspaceUserId: workspaceUser.id,
        ),
      ),
      child: CardContainer(
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          dense: true,
          leading: Hero(
            tag: 'workspace-user-${workspaceUser.id}',
            child: AppAvatar(
              hashString: workspaceUser.id,
              firstName: workspaceUser.firstName,
              imageUrl: workspaceUser.profileImageUrl,
            ),
          ),
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 4,
            children: [
              if (workspaceUser.email != null)
                Text(
                  workspaceUser.email!,
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    fontWeight: FontWeight.normal,
                  ),
                ),
              Text(
                workspaceUser.fullName,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  height: 1,
                ),
              ),
            ],
          ),
          trailing: WorkspaceUserTileTrailing(
            viewModel: viewModel,
            workspaceUser: workspaceUser,
            isCurrentUser: isCurrentUser,
          ),
        ),
      ),
    );
  }
}
