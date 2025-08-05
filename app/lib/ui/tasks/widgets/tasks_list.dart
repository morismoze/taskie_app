import 'package:flutter/material.dart';

import '../view_models/tasks_screen_viewmodel.dart';
import 'empty_filtered_tasks.dart';
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
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: TaskCard(
              appLocale: viewModel.appLocale,
              activeWorkspaceId: viewModel.activeWorkspaceId,
              taskId: task.id,
              title: task.title,
              assignees: task.assignees,
              rewardPoints: task.rewardPoints,
              dueDate: task.dueDate,
              isNew: task.isNew,
            ),
          );
        }, childCount: viewModel.tasks!.items.length),
      );
    }

    return const SliverFillRemaining(
      hasScrollBody: false,
      child: EmptyFilteredTasks(),
    );
  }
}
