import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../../../data/services/api/workspace/progress_status.dart';
import '../../../../domain/models/workspace_task.dart';
import '../../../core/ui/objective_status_chip.dart';
import '../../../core/utils/color.dart';

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
      final (textColor, backgroundColor) = ColorsUtils.getProgressStatusColors(
        status,
      );

      return ObjectiveStatusChip(
        status: status,
        textColor: textColor,
        backgroundColor: backgroundColor,
      );
    }

    if (assignees.every(
      (assignee) => assignee.status == ProgressStatus.closed,
    )) {
      final (textColor, backgroundColor) = ColorsUtils.getProgressStatusColors(
        ProgressStatus.closed,
      );

      return ObjectiveStatusChip(
        status: ProgressStatus.closed,
        textColor: textColor,
        backgroundColor: backgroundColor,
      );
    }

    return Row(
      spacing: 4,
      children: assignees.mapIndexed((index, assignee) {
        final (textColor, _) = ColorsUtils.getProgressStatusColors(
          assignee.status,
        );

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
}
