import 'package:flutter/material.dart';

import '../../../core/ui/activity_indicator.dart';
import '../../view_models/tasks_screen_view_model.dart';
import 'filter_by_status_button.dart';
import 'sort_by_time_button.dart';

class TasksFilteringHeader extends StatelessWidget {
  const TasksFilteringHeader({super.key, required this.viewModel});

  final TasksScreenViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 13,
      children: [
        SortByTimeButton(viewModel: viewModel),
        FilterByStatusButton(viewModel: viewModel),
        const Spacer(),
        ListenableBuilder(
          listenable: viewModel.loadTasks,
          builder: (_, child) {
            // Show loader in cases it's not force fetch
            if (viewModel.loadTasks.running && !viewModel.isForceFetching) {
              return child!;
            }
            return const SizedBox.shrink();
          },
          child: const ActivityIndicator(radius: 12),
        ),
      ],
    );
  }
}
