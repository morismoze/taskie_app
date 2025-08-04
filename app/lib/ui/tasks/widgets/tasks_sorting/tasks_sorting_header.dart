import 'package:flutter/material.dart';

import '../../view_models/tasks_screen_viewmodel.dart';
import 'sort_by_status_button.dart';
import 'sort_by_time_button.dart';

class TasksSortingHeader extends StatelessWidget {
  const TasksSortingHeader({super.key, required this.viewModel});

  final TasksScreenViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 13,
      children: [
        SortByTimeButton(viewModel: viewModel),
        SortByStatusButton(viewModel: viewModel),
      ],
    );
  }
}
