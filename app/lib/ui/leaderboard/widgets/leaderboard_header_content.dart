import 'package:flutter/material.dart';

import '../../../config/assets.dart';
import '../../core/l10n/l10n_extensions.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/dimens.dart';

class LeaderboardHeaderContent extends StatelessWidget {
  const LeaderboardHeaderContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: Dimens.paddingVertical / 3,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          spacing: Dimens.paddingVertical / 6,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: Image(
                image: AssetImage(Assets.laurelWreathLeft),
                width: 25,
              ),
            ),
            Text(
              context.localization.leaderboardLabel,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: AppColors.golden,
                fontWeight: FontWeight.bold,
                height: 1,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: Image(
                image: AssetImage(Assets.laurelWreathRight),
                width: 25,
              ),
            ),
          ],
        ),
        Text(
          context.localization.leaderboardSubtitle,
          style: Theme.of(context).textTheme.labelMedium!.copyWith(
            color: AppColors.grey3,
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
