import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../domain/models/workspace_task.dart';
import '../../../../routing/routes.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/dimens.dart';
import '../../../core/ui/new_objective_badge.dart';
import 'assignees.dart';
import 'due_date.dart';
import 'reward_points.dart';
import 'statuses.dart';
import 'title.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    required this.taskId,
    required this.title,
    required this.assignees,
    required this.rewardPoints,
    required this.appLocale,
    required this.isNew,
    required this.activeWorkspaceId,
    required this.dueDate,
  });

  final String taskId;
  final String title;
  final List<WorkspaceTaskAssignee> assignees;
  final int rewardPoints;
  final Locale appLocale;

  /// This represents a task was just created and was placed in the
  /// current active list of tasks regardless the current active filters.
  /// It is used to add visual elements to the card to distinguish newly
  /// created tasks from existing ones in the list
  final bool isNew;
  final String activeWorkspaceId;
  final DateTime? dueDate;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key('task-card-$taskId'),
      child: InkWell(
        onTap: () => context.push(
          Routes.taskEditDetails(
            workspaceId: activeWorkspaceId,
            taskId: taskId,
          ),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: Dimens.paddingVertical / 2,
            horizontal: Dimens.paddingHorizontal,
          ),
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
          child: Column(
            spacing: 10,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 10,
                children: [
                  Flexible(child: TaskTitle(title: title)),
                  Padding(
                    // Padding is used to accomodate line height
                    // of the font-family in TaskTitle. Setting
                    // `height: 1` to the text in TaskTitle is not
                    // an option because in that case there won't
                    // be needed line height between lines when long
                    // text wraps to new line.
                    padding: const EdgeInsets.only(top: 2),
                    child: Row(
                      spacing: 6,
                      children: [
                        if (isNew) const NewObjectiveBadge(),
                        TaskStatuses(assignees: assignees),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    spacing: 6,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TaskAssignees(assignees: assignees),
                      if (dueDate != null) ...[
                        const SizedBox(height: 1),
                        TaskDueDate(dueDate: dueDate!, appLocale: appLocale),
                      ],
                    ],
                  ),
                  TaskRewardPoints(rewardPoints: rewardPoints),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
