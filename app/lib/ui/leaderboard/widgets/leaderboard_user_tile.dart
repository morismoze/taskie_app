import 'package:flutter/material.dart';

import '../../core/l10n/l10n_extensions.dart';
import '../../core/theme/colors.dart';
import '../../core/ui/app_avatar.dart';
import '../../core/ui/card_container.dart';
import '../../core/utils/extensions.dart';
import '../../core/utils/user.dart';

class LeaderboardUserTile extends StatelessWidget {
  const LeaderboardUserTile({
    super.key,
    required this.placement,
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.accumulatedPoints,
    required this.completedTasks,
    required this.profileImageUrl,
  });

  final int placement;
  final String userId;
  final String firstName;
  final String lastName;
  final int accumulatedPoints;
  final int completedTasks;
  final String? profileImageUrl;

  @override
  Widget build(BuildContext context) {
    final fullName = UserUtils.constructFullName(
      firstName: firstName,
      lastName: lastName,
    );
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
            hashString: userId,
            firstName: firstName,
            imageUrl: profileImageUrl,
            size: 40,
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              spacing: 2,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fullName,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.titleMedium!
                      .copyWith(color: AppColors.grey2)
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  context.localization.leaderboardCompletedTasksLabel(
                    completedTasks,
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
            '${accumulatedPoints.toString()} ${context.localization.misc_pointsAbbr}',
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
