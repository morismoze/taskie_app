import 'package:flutter/material.dart';

import '../../../domain/models/workspace_task.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/dimens.dart';
import '../../core/ui/objective_status_chip.dart';
import '../../core/utils/color.dart';
import '../../core/utils/user.dart';

class TaskAssignmentsDetails extends StatelessWidget {
  const TaskAssignmentsDetails({super.key, required this.assignments});

  final List<WorkspaceTaskAssignee> assignments;

  @override
  Widget build(BuildContext context) {
    // Calculates row with the biggest width, so that all others are the same width
    return IntrinsicWidth(
      child: Column(
        spacing: Dimens.paddingVertical / 2,
        children: assignments.map((assignment) {
          final (textColor, backgroundColor) =
              ColorsUtils.getProgressStatusColors(assignment.status);

          return Row(
            spacing: Dimens.paddingHorizontal,
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    UserUtils.constructFullName(
                      firstName: assignment.firstName,
                      lastName: assignment.lastName,
                    ),
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
                    status: assignment.status,
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
