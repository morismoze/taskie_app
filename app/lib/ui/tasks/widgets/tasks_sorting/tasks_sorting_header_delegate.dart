import 'package:flutter/material.dart';

import '../../view_models/tasks_screen_viewmodel.dart';
import 'tasks_sorting_header.dart';

class TasksSortingHeaderDelegate extends SliverPersistentHeaderDelegate {
  const TasksSortingHeaderDelegate({
    required this.viewModel,
    required this.height,
  });

  final TasksScreenViewModel viewModel;
  final double height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return ListenableBuilder(
      listenable: Listenable.merge([viewModel, viewModel.loadTasks]),
      builder: (_, _) => TasksSortingHeader(viewModel: viewModel),
    );
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(covariant TasksSortingHeaderDelegate oldDelegate) {
    return viewModel.activeFilter != oldDelegate.viewModel.activeFilter ||
        viewModel.loadTasks.running != oldDelegate.viewModel.loadTasks.running;
  }
}
