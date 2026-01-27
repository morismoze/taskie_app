import 'package:flutter/material.dart';

import '../../../../domain/models/workspace_task.dart';
import '../../../core/ui/objective_status_chip.dart';
import '../../../core/utils/extensions.dart';

/// If the task has only one assignee, this will show full chip
/// with status text and corresponding color. If there is more
/// than one assignee, then this will show small bullets, each
/// connected to a assignee, with corresponding color for each
/// bullet depending on the task status of the assignee in question.
/// If there is more than one assignee and all of them have the
/// same status this will show full chip with status text and
/// corresponding color
class TaskStatuses extends StatelessWidget {
  const TaskStatuses({super.key, required this.assignees});

  final List<WorkspaceTaskAssignee> assignees;

  @override
  Widget build(BuildContext context) {
    if (assignees.isEmpty) {
      // Workspace user got removed or the user deleted account
      return const SizedBox.shrink();
    }

    // Show only the status chip if all the assignees have the same status
    if (assignees.every((assignee) => assignee.status == assignees[0].status)) {
      final status = assignees[0].status;
      final (:textColor, :backgroundColor) = status.colors;

      return ObjectiveStatusChip(
        status: status,
        textColor: textColor,
        backgroundColor: backgroundColor,
      );
    }

    // Show statuses bullets
    return Row(
      spacing: 4,
      children: assignees.map((assignee) {
        final (:textColor, :backgroundColor) = assignee.status.colors;

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
