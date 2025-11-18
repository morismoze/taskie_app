import 'package:flutter/material.dart';

import '../../../data/services/api/workspace/progress_status.dart';
import '../view_models/goals_screen_viewmodel.dart';
import 'empty_filtered_goals.dart';
import 'goal_card/card.dart';

class GoalsList extends StatelessWidget {
  const GoalsList({super.key, required this.viewModel});

  final GoalsScreenViewmodel viewModel;

  @override
  Widget build(BuildContext context) {
    if (viewModel.goals!.total > 0) {
      return SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final goal = viewModel.goals!.items[index];

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: GoalCard(
              viewModel: viewModel,
              goalId: goal.id,
              title: goal.title,
              assignee: goal.assignee,
              requiredPoints: goal.requiredPoints,
              accumulatedPoints: goal.accumulatedPoints,
              isNew: goal.isNew,
              isGoalClosed: goal.status == ProgressStatus.closed,
            ),
          );
        }, childCount: viewModel.goals!.items.length),
      );
    }

    return const SliverFillRemaining(
      hasScrollBody: false,
      child: EmptyFilteredGoals(),
    );
  }
}
