import 'package:flutter/material.dart';

import '../../../data/services/api/workspace/progress_status.dart';
import '../../core/l10n/l10n_extensions.dart';
import '../../core/theme/dimens.dart';
import '../../core/ui/empty_filtered_objectives.dart';
import '../view_models/goals_screen_view_model.dart';
import 'goal_card/card.dart';

class GoalsList extends StatelessWidget {
  const GoalsList({super.key, required this.viewModel});

  final GoalsScreenViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    if (viewModel.goals!.total > 0) {
      return SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final goal = viewModel.goals!.items[index];

          return Padding(
            padding: const EdgeInsets.symmetric(
              vertical: Dimens.paddingVertical / 4,
            ),
            child: GoalCard(
              viewModel: viewModel,
              goalId: goal.id,
              title: goal.title,
              assignee: goal.assignee,
              requiredPoints: goal.requiredPoints,
              accumulatedPoints: goal.accumulatedPoints,
              status: goal.status,
              isNew: goal.isNew,
              isGoalClosed: goal.status == ProgressStatus.closed,
            ),
          );
        }, childCount: viewModel.goals!.items.length),
      );
    }

    return SliverFillRemaining(
      hasScrollBody: false,
      child: EmptyFilteredObjectives(
        text: context.localization.goalsNoFilteredGoals,
      ),
    );
  }
}
