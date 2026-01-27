import 'package:flutter/material.dart';

import '../../core/l10n/l10n_extensions.dart';
import '../../core/theme/dimens.dart';
import '../../core/ui/empty_filtered_objectives.dart';
import '../view_models/workspace_users_management_screen_view_model.dart';
import 'workspace_user_tile.dart';

class UsersList extends StatelessWidget {
  const UsersList({super.key, required this.viewModel});

  final WorkspaceUsersManagementScreenViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    if (viewModel.users!.isNotEmpty) {
      return SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final workspaceUser = viewModel.users![index];
          final currentUser = viewModel.currentUser;
          final isCurrentUser = currentUser.id == workspaceUser.userId;

          return Padding(
            padding: const EdgeInsets.symmetric(
              vertical: Dimens.paddingVertical / 4,
            ),
            child: WorkspaceUserTile(
              viewModel: viewModel,
              workspaceUser: workspaceUser,
              isCurrentUser: isCurrentUser,
            ),
          );
        }, childCount: viewModel.users!.length),
      );
    }

    return SliverFillRemaining(
      hasScrollBody: false,
      child: EmptyFilteredObjectives(
        text: context.localization.workspaceUsersManagementLoadUsersEmpty,
      ),
    );
  }
}
