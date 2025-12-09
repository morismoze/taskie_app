import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../../data/services/api/workspace/progress_status.dart';
import '../../../../domain/constants/rbac.dart';
import '../../../../domain/models/assignee.dart';
import '../../../../routing/routes.dart';
import '../../../core/l10n/l10n_extensions.dart';
import '../../../core/ui/app_avatar.dart';
import '../../../core/ui/app_modal_bottom_sheet.dart';
import '../../../core/ui/app_text_button.dart';
import '../../../core/ui/card_container.dart';
import '../../../core/ui/new_objective_badge.dart';
import '../../../core/ui/objective_status_chip.dart';
import '../../../core/ui/rbac.dart';
import '../../../core/utils/color.dart';
import '../../view_models/goals_screen_viewmodel.dart';
import 'progress.dart';
import 'title.dart';

class GoalCard extends StatelessWidget {
  const GoalCard({
    super.key,
    required this.goalId,
    required this.title,
    required this.assignee,
    required this.requiredPoints,
    required this.accumulatedPoints,
    required this.status,
    required this.isNew,
    required this.viewModel,
    required this.isGoalClosed,
  });

  final String goalId;
  final String title;
  final Assignee assignee;
  final int requiredPoints;
  final int accumulatedPoints;
  final ProgressStatus status;

  /// This represents a goal was just created and was placed in the
  /// current active list of goals regardless the current active filters.
  /// It is used to add visual elements to the card to distinguish newly
  /// created goals from existing ones in the list
  final bool isNew;
  final GoalsScreenViewmodel viewModel;
  final bool isGoalClosed;

  @override
  Widget build(BuildContext context) {
    final (textColor, backgroundColor) = ColorsUtils.getProgressStatusColors(
      status,
    );

    return InkWell(
      onTap: () =>
          _onTap(context, viewModel.activeWorkspaceId, goalId, isGoalClosed),
      child: CardContainer(
        child: Column(
          spacing: 15,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 10,
              children: [
                AppAvatar(
                  hashString: assignee.id,
                  firstName: assignee.firstName,
                  imageUrl: assignee.profileImageUrl,
                  size: 25,
                ),
                Expanded(child: GoalTitle(title: title)),
                if (isNew) const NewObjectiveBadge(),
                ObjectiveStatusChip(
                  status: status,
                  textColor: textColor,
                  backgroundColor: backgroundColor,
                ),
              ],
            ),
            GoalProgress(
              requiredPoints: requiredPoints,
              accumulatedPoints: accumulatedPoints,
            ),
          ],
        ),
      ),
    );
  }

  void _onTap(
    BuildContext context,
    String activeWorkspaceId,
    String goalId,
    bool isGoalClosed,
  ) {
    AppModalBottomSheet.show(
      context: context,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppTextButton(
            onPress: () {
              context.pop(); // Close bottom sheet
              context.push(
                Routes.goalDetails(
                  workspaceId: activeWorkspaceId,
                  goalId: goalId,
                ),
              );
            },
            label: context.localization.goalsDetails,
            leadingIcon: FontAwesomeIcons.circleInfo,
          ),
          if (!isGoalClosed)
            Rbac(
              permission: RbacPermission.objectiveEdit,
              child: AppTextButton(
                onPress: () {
                  context.pop(); // Close bottom sheet
                  context.push(
                    Routes.goalDetailsEdit(
                      workspaceId: activeWorkspaceId,
                      goalId: goalId,
                    ),
                  );
                },
                label: context.localization.goalsDetailsEdit,
                leadingIcon: FontAwesomeIcons.pencil,
              ),
            ),
        ],
      ),
    );
  }
}
