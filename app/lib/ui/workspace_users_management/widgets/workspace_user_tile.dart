import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../data/services/api/user/models/response/user_response.dart';
import '../../../routing/routes.dart';
import '../../core/ui/app_avatar.dart';
import '../../core/ui/card_container.dart';
import '../../core/utils/user.dart';
import '../view_models/workspace_users_management_screen_viewmodel.dart';
import 'workspace_user_tile_trailing.dart';

class WorkspaceUserTile extends StatelessWidget {
  const WorkspaceUserTile({
    super.key,
    required this.viewModel,
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.isCurrentUser,
    this.email,
    this.profileImageUrl,
  });

  final WorkspaceUsersManagementScreenViewModel viewModel;
  final String id;
  final String firstName;
  final String lastName;
  final WorkspaceRole role;
  final bool isCurrentUser;
  final String? email;
  final String? profileImageUrl;

  @override
  Widget build(BuildContext context) {
    final fullName = UserUtils.constructFullName(
      firstName: firstName,
      lastName: lastName,
    );

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => context.push(
        Routes.workspaceUsersWithId(
          workspaceId: viewModel.activeWorkspaceId,
          workspaceUserId: id,
        ),
      ),
      child: CardContainer(
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          dense: true,
          leading: Hero(
            tag: 'workspace-user-$id',
            child: AppAvatar(
              hashString: id,
              firstName: firstName,
              imageUrl: profileImageUrl,
            ),
          ),
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 4,
            children: [
              if (email != null)
                Text(
                  email!,
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    fontWeight: FontWeight.normal,
                  ),
                ),
              Text(
                fullName,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  height: 1,
                ),
              ),
            ],
          ),
          trailing: WorkspaceUserTileTrailing(
            viewModel: viewModel,
            workspaceUserId: id,
            role: role,
            firstName: firstName,
            lastName: lastName,
            profileImageUrl: profileImageUrl,
            isCurrentUser: isCurrentUser,
          ),
        ),
      ),
    );
  }
}
