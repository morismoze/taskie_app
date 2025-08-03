import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../../../data/services/api/workspace/progress_status.dart';
import '../../../../domain/models/workspace_task.dart';
import '../../../core/theme/colors.dart';
import '../../../core/utils/extensions.dart';

/// If the task has only one assignee, this will show full chip
/// with status text and corresponding color. If there are more
/// than one assignees, then this will show small bullets, each
/// connected to a assignee, with corresponding color for each
/// bullet depending on the status of the assignee in question.
class TaskStatuses extends StatelessWidget {
  const TaskStatuses({super.key, required this.assignees});

  final List<WorkspaceTaskAssignee> assignees;

  @override
  Widget build(BuildContext context) {
    if (assignees.length == 1) {
      final (textColor, backgroundColor, text) = _getStatusMeta(
        assignees[0].status,
        context,
      );

      return Container(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
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
        final (textColor, _, _) = _getStatusMeta(assignee.status, context);

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

  (Color textColor, Color backgroundColor, String text) _getStatusMeta(
    ProgressStatus status,
    BuildContext context,
  ) {
    switch (status) {
      case ProgressStatus.inProgress:
        return (
          AppColors.orange1,
          AppColors.orange1Light,
          status.l10n(context),
        );
      case ProgressStatus.completed:
        return (AppColors.green1, AppColors.green1Light, status.l10n(context));
      case ProgressStatus.completedAsStale:
        return (AppColors.pink1, AppColors.pink1Light, status.l10n(context));
      case ProgressStatus.closed:
        return (
          Theme.of(context).colorScheme.primary,
          AppColors.purple1Light,
          status.l10n(context),
        );
    }
  }
}
