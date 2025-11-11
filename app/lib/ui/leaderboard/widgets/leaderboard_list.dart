import 'package:flutter/material.dart';

import '../../../domain/models/workspace_leaderboard_user.dart';
import '../../core/theme/dimens.dart';
import '../../navigation/app_bottom_navigation_bar/widgets/app_bottom_navigation_bar.dart';
import '../../navigation/app_fab/widgets/app_floating_action_button.dart';
import 'leaderboard_user_tile.dart';

class LeaderboardList extends StatelessWidget {
  const LeaderboardList({super.key, required this.items});

  final List<WorkspaceLeaderboardUser> items;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.only(
        left: Dimens.of(context).paddingScreenHorizontal,
        right: Dimens.of(context).paddingScreenHorizontal,
        top: Dimens.paddingVertical,
        bottom:
            Dimens.paddingVertical * 1.5 +
            kAppFloatingActionButtonSize +
            kAppBottomNavigationBarHeight,
      ),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final user = items[index];

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: LeaderboardUserTile(
              placement: index + 1,
              userId: user.id,
              firstName: user.firstName,
              lastName: user.lastName,
              profileImageUrl: user.profileImageUrl,
              accumulatedPoints: user.accumulatedPoints,
              completedTasks: user.completedTasks,
            ),
          );
        }, childCount: items.length),
      ),
    );
  }
}
