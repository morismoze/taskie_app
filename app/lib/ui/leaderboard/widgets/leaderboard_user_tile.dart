import 'package:flutter/material.dart';

import '../../core/l10n/l10n_extensions.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/dimens.dart';
import '../../core/ui/app_avatar.dart';
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

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: Dimens.paddingVertical / 2,
        horizontal: Dimens.paddingHorizontal,
      ),
      decoration: BoxDecoration(
        color: AppColors.white1,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          const BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.1),
            blurRadius: 12,
            spreadRadius: 0,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          _Placement(placement: placement),
          const SizedBox(width: 15),
          AppAvatar(
            hashString: userId,
            firstName: firstName,
            imageUrl: profileImageUrl,
            size: 50,
          ),
          const SizedBox(width: 15),
          Text(
            fullName,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge!
                .copyWith(color: AppColors.grey2)
                .copyWith(fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          Text(
            '${accumulatedPoints.toString()} ${context.localization.misc_pointsAbbr}',
            style: Theme.of(
              context,
            ).textTheme.titleLarge!.copyWith(color: AppColors.grey2),
          ),
        ],
      ),
    );
  }
}

class _Placement extends StatelessWidget {
  const _Placement({required this.placement});

  final int placement;

  @override
  Widget build(BuildContext context) {
    const fixedWidth = 40.0;

    if (placement <= 3) {
      final (borderColor, backgroundColor, textColor) = switch (placement) {
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
          AppColors.bronze,
          AppColors.bronze.lighten(0.7),
          AppColors.bronze.darken(0.4),
        ),
      };

      return Container(
        width: fixedWidth,
        height: fixedWidth,
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(color: borderColor, width: 3.5),
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
            color: AppColors.green1,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
