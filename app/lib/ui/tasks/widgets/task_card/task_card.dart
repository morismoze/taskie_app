import 'package:flutter/material.dart';

import '../../../../data/services/api/workspace/progress_status.dart';
import '../../../../domain/models/workspace_task.dart';
import '../../../core/theme/colors.dart';
import 'task_assignees.dart';
import 'task_due_date.dart';
import 'task_status.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    required this.title,
    required this.assignees,
    required this.rewardPoints,
    required this.status,
    required this.appLocale,
    this.isNew = false,
    this.dueDate,
  });

  final String title;
  final List<WorkspaceTaskAssignee> assignees;
  final int rewardPoints;
  final ProgressStatus status;
  final Locale appLocale;

  /// This represents a task was just created and was placed in the
  /// current active list of tasks regardless the current active filters.
  /// It is used to add visual elements to the card to distinguish newly
  /// created tasks from existing ones in the list
  final bool isNew;
  final DateTime? dueDate;

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Column(
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              TaskAssignees(assignees: assignees),
            ],
          ),
          Column(
            children: [
              if (dueDate != null)
                TaskDueDate(dueDate: dueDate!, appLocale: appLocale),
              TaskStatus(status: status),
            ],
          ),
        ],
      ),
    );
  }
}
