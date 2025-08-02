import 'package:flutter/material.dart';

import '../../core/ui/paginated_list_view.dart';
import '../view_models/tasks_screen_viewmodel.dart';
import 'task_card/card.dart';

class TasksList extends StatelessWidget {
  const TasksList({super.key, required this.viewModel});

  final TasksScreenViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return PaginatedListView(
      totalPages: viewModel.tasks!.totalPages,
      onPageChange: (page) {
        final updatedFilter = viewModel.activeFilter.copyWith(page: page + 1);
        viewModel.loadTasks.execute((updatedFilter, null));
      },
      itemBuilder: (context, index) {
        final task = viewModel.tasks!.items[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: TaskCard(
            appLocale: viewModel.appLocale,
            title: task.title,
            assignees: task.assignees,
            rewardPoints: task.rewardPoints,
            dueDate: task.dueDate,
          ),
        );
      },
      childCount: viewModel.tasks!.items.length,
    );
  }
}
