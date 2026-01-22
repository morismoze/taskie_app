import 'package:flutter/material.dart';

import '../../view_models/tasks_screen_view_model.dart';
import 'tasks_filtering_header.dart';

class TasksFilteringHeaderDelegate extends SliverPersistentHeaderDelegate {
  const TasksFilteringHeaderDelegate({
    required this.viewModel,
    required this.height,
  });

  final TasksScreenViewModel viewModel;
  final double height;

  @override
  Widget build(_, _, _) {
    return TasksFilteringHeader(viewModel: viewModel);
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(covariant TasksFilteringHeaderDelegate oldDelegate) {
    return viewModel.activeFilter != oldDelegate.viewModel.activeFilter ||
        viewModel.loadTasks.running != oldDelegate.viewModel.loadTasks.running;
  }
}
