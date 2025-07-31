import 'package:flutter/material.dart';

import '../../../../data/services/api/workspace/progress_status.dart';
import '../../../core/l10n/l10n_extensions.dart';
import '../../../core/theme/colors.dart';

class TaskStatus extends StatelessWidget {
  const TaskStatus({super.key, required this.status});

  final ProgressStatus status;

  @override
  Widget build(BuildContext context) {
    final (textColor, backgroundColor, text) = switch (status) {
      ProgressStatus.inProgress => (
        AppColors.orange1,
        AppColors.orange1Light,
        context.localization.tasksProgressInProgress,
      ),
      ProgressStatus.completed => (
        AppColors.green1,
        AppColors.green1Light,
        context.localization.tasksProgressCompleted,
      ),
      ProgressStatus.completedAsStale => (
        AppColors.pink1,
        AppColors.pink1Light,
        context.localization.tasksProgressCompletedAsStale,
      ),
      ProgressStatus.closed => (
        AppColors.purple1,
        AppColors.purple1Light,
        context.localization.tasksProgressClosed,
      ),
    };

    return Chip(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 2),
      side: BorderSide.none,
      backgroundColor: backgroundColor,
      label: Text(
        text,
        style: Theme.of(context).textTheme.labelMedium!.copyWith(
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }
}
