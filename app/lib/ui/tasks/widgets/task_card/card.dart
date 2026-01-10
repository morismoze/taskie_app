import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../../domain/constants/rbac.dart';
import '../../../../domain/models/workspace_task.dart';
import '../../../../routing/routes.dart';
import '../../../core/l10n/l10n_extensions.dart';
import '../../../core/ui/app_modal_bottom_sheet.dart';
import '../../../core/ui/app_modal_bottom_sheet_content_wrapper.dart';
import '../../../core/ui/app_text_button.dart';
import '../../../core/ui/card_container.dart';
import '../../../core/ui/new_objective_badge.dart';
import '../../../core/ui/rbac.dart';
import '../../view_models/tasks_screen_viewmodel.dart';
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
    required this.isNew,
    required this.viewModel,
    required this.isTaskClosed,
    required this.dueDate,
  });

  final String taskId;
  final String title;
  final List<WorkspaceTaskAssignee> assignees;
  final int rewardPoints;

  /// This represents a task was just created and was placed in the
  /// current active list of tasks regardless the current active filters.
  /// It is used to add visual elements to the card to distinguish newly
  /// created tasks from existing ones in the list
  final bool isNew;
  final TasksScreenViewModel viewModel;
  final bool isTaskClosed;
  final DateTime? dueDate;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _onTap(context, title, viewModel.activeWorkspaceId, taskId),
      child: CardContainer(
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
                      TaskDueDate(
                        dueDate: dueDate!,
                        appLocale: viewModel.appLocale,
                      ),
                    ],
                  ],
                ),
                TaskRewardPoints(rewardPoints: rewardPoints),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _onTap(
    BuildContext context,
    String title,
    String activeWorkspaceId,
    String taskId,
  ) {
    AppModalBottomSheet.show(
      context: context,
      child: AppModalBottomSheetContentWrapper(
        title: title,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppTextButton(
              onPress: () {
                context.push(
                  Routes.taskDetails(
                    workspaceId: activeWorkspaceId,
                    taskId: taskId,
                  ),
                );
              },
              label: context.localization.tasksDetails,
              leadingIcon: FontAwesomeIcons.circleInfo,
            ),
            if (!isTaskClosed)
              Rbac(
                permission: RbacPermission.objectiveEdit,
                child: AppTextButton(
                  onPress: () {
                    context.push(
                      Routes.taskDetailsEdit(
                        workspaceId: activeWorkspaceId,
                        taskId: taskId,
                      ),
                    );
                  },
                  label: context.localization.tasksDetailsEdit,
                  leadingIcon: FontAwesomeIcons.pencil,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
