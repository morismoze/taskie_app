import 'package:flutter/material.dart';

import '../../../domain/models/workspace_user.dart';
import '../../core/l10n/l10n_extensions.dart';
import '../../core/ui/activity_indicator.dart';
import '../view_models/create_goal_screen_viewmodel.dart';

class WorkspaceUserAccumulatedPoints extends StatelessWidget {
  const WorkspaceUserAccumulatedPoints({
    super.key,
    required this.viewModel,
    required this.selectedAssignee,
  });

  final CreateGoalScreenViewmodel viewModel;
  final WorkspaceUser selectedAssignee;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel.loadWorkspaceUserAccumulatedPoints,
      builder: (builderContext, child) {
        if (viewModel.loadWorkspaceUserAccumulatedPoints.running) {
          return ActivityIndicator(
            radius: 16,
            color: Theme.of(builderContext).colorScheme.primary,
          );
        }

        if (viewModel.loadWorkspaceUserAccumulatedPoints.error) {
          // TODO: Usage of a generic error prompt widget
          return const SizedBox.shrink();
        }

        return child!;
      },
      child: ListenableBuilder(
        listenable: viewModel,
        builder: (innerBuilderContext, _) {
          final fullName =
              '${selectedAssignee.firstName} ${selectedAssignee.lastName}';

          return Text.rich(
            textAlign: TextAlign.left,
            TextSpan(
              text:
                  '${innerBuilderContext.localization.goalRequiredPointsCurrentAccumulatedPoints} ',
              style: Theme.of(innerBuilderContext).textTheme.labelMedium!
                  .copyWith(fontSize: 15, fontWeight: FontWeight.normal),
              children: [
                TextSpan(
                  text: '$fullName: ',
                  style: Theme.of(innerBuilderContext).textTheme.labelMedium!
                      .copyWith(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: viewModel.workspaceUserAccumulatedPoints!.toString(),
                  style: Theme.of(innerBuilderContext).textTheme.labelMedium!
                      .copyWith(
                        fontSize: 15,
                        color: Theme.of(
                          innerBuilderContext,
                        ).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        height: 1,
                      ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
