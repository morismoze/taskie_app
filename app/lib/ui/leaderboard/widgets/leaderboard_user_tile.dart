import 'package:flutter/material.dart';

import '../../../domain/models/interfaces/user_interface.dart';
import '../../../domain/models/workspace_leaderboard_user.dart';
import '../../core/l10n/l10n_extensions.dart';
import '../../core/theme/colors.dart';
import '../../core/ui/app_avatar.dart';
import '../../core/ui/card_container.dart';
import '../../core/utils/extensions.dart';

class LeaderboardUserTile extends StatelessWidget {
  const LeaderboardUserTile({
    super.key,
    required this.placement,
    required this.user,
  });

  final int placement;
  final WorkspaceLeaderboardUser user;

  @override
  Widget build(BuildContext context) {
    final (placementBorderColor, placementBackgroundColor, placementTextColor) =
        _getPlacementColorScheme();

    return CardContainer(
      child: Row(
        children: [
          _Placement(
            placement: placement,
            borderColor: placementBorderColor,
            backgroundColor: placementBackgroundColor,
            textColor: placementTextColor,
          ),
          const SizedBox(width: 15),
          AppAvatar(
            hashString: user.id,
            firstName: user.firstName,
            imageUrl: user.profileImageUrl,
            size: 40,
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              spacing: 2,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.fullName,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.titleMedium!
                      .copyWith(color: AppColors.grey2)
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  context.localization.leaderboardCompletedTasksLabel(
                    user.completedTasks,
                  ),
                  style: Theme.of(
                    context,
                  ).textTheme.labelMedium!.copyWith(color: AppColors.grey3),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '${user.accumulatedPoints.toString()} ${context.localization.misc_pointsAbbr}',
            style: Theme.of(
              context,
            ).textTheme.titleLarge!.copyWith(color: placementBorderColor),
          ),
        ],
      ),
    );
  }

  (Color borderColor, Color backgroundColor, Color textColor)
  _getPlacementColorScheme() {
    return switch (placement) {
      1 => (
        AppColors.golden,
        AppColors.golden.lighten(0.7),
        AppColors.golden.darken(0.4),
      ),
      2 => (
        AppColors.silver,
        AppColors.silver.lighten(0.7),
        AppColors.silver.darken(0.4),
      ),
      3 => (
        AppColors.bronze,
        AppColors.bronze.lighten(0.7),
        AppColors.bronze.darken(0.4),
      ),
      _ => (
        AppColors.purple1,
        AppColors.purple1.lighten(0.7),
        AppColors.purple1,
      ),
    };
  }
}

class _Placement extends StatelessWidget {
  const _Placement({
    required this.placement,
    required this.borderColor,
    required this.backgroundColor,
    required this.textColor,
  });

  final int placement;
  final Color borderColor;
  final Color backgroundColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    const fixedWidth = 30.0;

    if (placement <= 3) {
      return Container(
        width: fixedWidth,
        height: fixedWidth,
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(color: borderColor, width: 2.5),
          borderRadius: BorderRadius.circular(fixedWidth),
        ),
        child: Center(
          child: Text(
            placement.toString(),
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }

    return SizedBox(
      width: fixedWidth,
      child: Center(
        child: Text(
          placement.toString(),
          style: Theme.of(context).textTheme.titleSmall!.copyWith(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
