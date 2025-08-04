import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../core/l10n/l10n_extensions.dart';
import '../../../core/theme/colors.dart';

class TaskRewardPoints extends StatelessWidget {
  const TaskRewardPoints({super.key, required this.rewardPoints});

  final int rewardPoints;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 4,
      children: [
        FaIcon(FontAwesomeIcons.gift, size: 16, color: AppColors.golden),
        Text(
          context.localization.tasksCardPoints(rewardPoints),
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: AppColors.golden,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
