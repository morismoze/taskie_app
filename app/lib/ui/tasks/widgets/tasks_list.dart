import 'package:flutter/material.dart';

import '../../../data/services/api/workspace/progress_status.dart';
import '../../core/l10n/l10n_extensions.dart';
import '../../core/ui/empty_filtered_objectives.dart';
import '../view_models/tasks_screen_viewmodel.dart';
import 'task_card/card.dart';

class TasksList extends StatelessWidget {
  const TasksList({super.key, required this.viewModel});

  final TasksScreenViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    if (viewModel.tasks!.total > 0) {
      return SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final task = viewModel.tasks!.items[index];
          final isTaskClosed = task.assignees.every(
            (assignment) => assignment.status == ProgressStatus.closed,
          );

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: TaskCard(
              viewModel: viewModel,
              taskId: task.id,
              title: task.title,
              assignees: task.assignees,
              rewardPoints: task.rewardPoints,
              dueDate: task.dueDate,
              isNew: task.isNew,
              isTaskClosed: isTaskClosed,
            ),
          );
        }, childCount: viewModel.tasks!.items.length),
      );
    }

    return SliverFillRemaining(
      hasScrollBody: false,
      child: EmptyFilteredObjectives(
        text: context.localization.taskskNoFilteredTasks,
      ),
    );
  }
}
