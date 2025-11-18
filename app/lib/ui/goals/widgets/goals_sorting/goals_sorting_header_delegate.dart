import 'package:flutter/material.dart';

import '../../view_models/goals_screen_viewmodel.dart';
import 'goals_sorting_header.dart';

class GoalsSortingHeaderDelegate extends SliverPersistentHeaderDelegate {
  const GoalsSortingHeaderDelegate({
    required this.viewModel,
    required this.height,
  });

  final GoalsScreenViewmodel viewModel;
  final double height;

  @override
  Widget build(_, _, _) {
    return GoalsSortingHeader(viewModel: viewModel);
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(covariant GoalsSortingHeaderDelegate oldDelegate) {
    return viewModel.activeFilter != oldDelegate.viewModel.activeFilter ||
        viewModel.loadGoals.running != oldDelegate.viewModel.loadGoals.running;
  }
}
