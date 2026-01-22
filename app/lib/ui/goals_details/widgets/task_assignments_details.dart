import 'package:flutter/material.dart';

import '../../../domain/models/interfaces/user_interface.dart';
import '../../../domain/models/workspace_task.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/dimens.dart';
import '../../core/ui/objective_status_chip.dart';
import '../../core/utils/extensions.dart';

class TaskAssignmentsDetails extends StatelessWidget {
  const TaskAssignmentsDetails({super.key, required this.assignments});

  final List<WorkspaceTaskAssignee> assignments;

  @override
  Widget build(BuildContext context) {
    // Calculates row with the biggest width, so that all others are the same width
    return IntrinsicWidth(
      child: Column(
        spacing: Dimens.paddingVertical / 2,
        children: assignments.map((assignee) {
          final (:textColor, :backgroundColor) = assignee.status.colors;

          return Row(
            spacing: Dimens.paddingHorizontal,
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    assignee.fullName,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: AppColors.grey2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: ObjectiveStatusChip(
                    status: assignee.status,
                    textColor: textColor,
                    backgroundColor: backgroundColor,
                  ),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
