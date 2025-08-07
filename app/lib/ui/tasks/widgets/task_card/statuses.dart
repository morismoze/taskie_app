import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../../../data/services/api/workspace/progress_status.dart';
import '../../../../domain/models/workspace_task.dart';
import '../../../core/theme/colors.dart';
import '../../../core/utils/extensions.dart';

/// If the task has only one assignee, this will show full chip
/// with status text and corresponding color. If there is more
/// than one assignee, then this will show small bullets, each
/// connected to a assignee, with corresponding color for each
/// bullet depending on the task status of the assignee in question.
class TaskStatuses extends StatelessWidget {
  const TaskStatuses({super.key, required this.assignees});

  final List<WorkspaceTaskAssignee> assignees;

  @override
  Widget build(BuildContext context) {
    if (assignees.length == 1) {
      final status = assignees[0].status;
      final (textColor, backgroundColor) = _getStatusMeta(status, context);

      return Badge(
        backgroundColor: backgroundColor,
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
        label: Text(
          status.l10n(context),
          style: Theme.of(context).textTheme.labelSmall!.copyWith(
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      );
    }

    return Row(
      spacing: 4,
      children: assignees.mapIndexed((index, assignee) {
        final (textColor, _) = _getStatusMeta(assignee.status, context);

        return Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: textColor,
            borderRadius: BorderRadius.circular(6),
          ),
        );
      }).toList(),
    );
  }

  (Color textColor, Color backgroundColor) _getStatusMeta(
    ProgressStatus status,
    BuildContext context,
  ) {
    switch (status) {
      case ProgressStatus.inProgress:
        return (AppColors.orange1, AppColors.orange1Light);
      case ProgressStatus.completed:
        return (AppColors.green1, AppColors.green1Light);
      case ProgressStatus.completedAsStale:
        return (AppColors.grey2, AppColors.grey3);
      case ProgressStatus.notCompleted:
        return (AppColors.red1, AppColors.red1Light);
      case ProgressStatus.closed:
        return (Theme.of(context).colorScheme.primary, AppColors.purple1Light);
    }
  }
}
