import 'package:flutter/material.dart';

import '../../../core/ui/activity_indicator.dart';
import '../../view_models/goals_screen_viewmodel.dart';
import 'sort_by_status_button.dart';
import 'sort_by_time_button.dart';

class GoalsSortingHeader extends StatelessWidget {
  const GoalsSortingHeader({super.key, required this.viewModel});

  final GoalsScreenViewmodel viewModel;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 13,
      children: [
        SortByTimeButton(viewModel: viewModel),
        SortByStatusButton(viewModel: viewModel),
        const Spacer(),
        ListenableBuilder(
          listenable: viewModel.loadGoals,
          builder: (_, child) {
            if (viewModel.loadGoals.running) {
              return child!;
            }
            return const SizedBox.shrink();
          },
          child: ActivityIndicator(
            radius: 12,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }
}
