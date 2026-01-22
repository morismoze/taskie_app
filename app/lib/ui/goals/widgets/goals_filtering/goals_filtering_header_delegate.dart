import 'package:flutter/material.dart';

import '../../view_models/goals_screen_view_model.dart';
import 'goals_filtering_header.dart';

class GoalsFilteringHeaderDelegate extends SliverPersistentHeaderDelegate {
  const GoalsFilteringHeaderDelegate({
    required this.viewModel,
    required this.height,
  });

  final GoalsScreenViewModel viewModel;
  final double height;

  @override
  Widget build(_, _, _) {
    return GoalsFilteringHeader(viewModel: viewModel);
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(covariant GoalsFilteringHeaderDelegate oldDelegate) {
    return viewModel.activeFilter != oldDelegate.viewModel.activeFilter ||
        viewModel.loadGoals.running != oldDelegate.viewModel.loadGoals.running;
  }
}
