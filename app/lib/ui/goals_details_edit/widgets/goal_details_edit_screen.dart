import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../data/services/api/exceptions/goal_closed_exception.dart';
import '../../../routing/routes.dart';
import '../../../utils/command.dart';
import '../../core/l10n/l10n_extensions.dart';
import '../../core/theme/dimens.dart';
import '../../core/ui/activity_indicator.dart';
import '../../core/ui/app_dialog.dart';
import '../../core/ui/app_filled_button.dart';
import '../../core/ui/app_snackbar.dart';
import '../../core/ui/blurred_circles_background.dart';
import '../../core/ui/header_bar/header_bar.dart';
import '../../core/ui/separator.dart';
import '../view_models/goal_details_edit_screen_view_model.dart';
import 'goal_close_button.dart';
import 'goal_details_edit_form.dart';
import 'goal_details_meta.dart';

class GoalDetailsEditScreen extends StatefulWidget {
  const GoalDetailsEditScreen({super.key, required this.viewModel});

  final GoalDetailsEditScreenViewModel viewModel;

  @override
  State<GoalDetailsEditScreen> createState() => _GoalDetailsEditScreenState();
}

class _GoalDetailsEditScreenState extends State<GoalDetailsEditScreen> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.editGoalDetails.addListener(_onGoalDetailsEditResult);
    widget.viewModel.closeGoal.addListener(_onGoalCloseResult);
  }

  @override
  void didUpdateWidget(covariant GoalDetailsEditScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.viewModel.editGoalDetails.removeListener(
      _onGoalDetailsEditResult,
    );
    oldWidget.viewModel.closeGoal.removeListener(_onGoalCloseResult);
    widget.viewModel.editGoalDetails.addListener(_onGoalDetailsEditResult);
    widget.viewModel.closeGoal.addListener(_onGoalCloseResult);
  }

  @override
  void dispose() {
    widget.viewModel.editGoalDetails.removeListener(_onGoalDetailsEditResult);
    widget.viewModel.closeGoal.removeListener(_onGoalCloseResult);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlurredCirclesBackground(
        child: SafeArea(
          child: Column(
            children: [
              HeaderBar(title: context.localization.goalsDetailsEdit),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimens.of(context).paddingScreenHorizontal,
                  ),
                  child: ListenableBuilder(
                    listenable: widget.viewModel,
                    builder: (builderContext, child) {
                      if (widget.viewModel.details == null ||
                          widget.viewModel.workspaceMembers.isEmpty) {
                        return ActivityIndicator(
                          radius: 16,
                          color: Theme.of(builderContext).colorScheme.primary,
                        );
                      }

                      return SingleChildScrollView(
                        padding: EdgeInsets.symmetric(
                          vertical: Dimens.of(context).paddingScreenVertical,
                        ),
                        child: Column(
                          children: [
                            GoalDetailsMeta(viewModel: widget.viewModel),
                            const SizedBox(height: 20),
                            const Separator(),
                            const SizedBox(height: 40),
                            GoalDetailsEditForm(viewModel: widget.viewModel),
                            const SizedBox(height: 40),
                            const Separator(),
                            const SizedBox(height: 40),
                            GoalCloseButton(viewModel: widget.viewModel),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onGoalDetailsEditResult() {
    if (widget.viewModel.editGoalDetails.completed) {
      widget.viewModel.editGoalDetails.clearResult();
      AppSnackbar.showSuccess(
        context: context,
        message: context.localization.goalsDetailsEditSuccess,
      );
    }

    if (widget.viewModel.editGoalDetails.error) {
      final errorResult = widget.viewModel.editGoalDetails.result as Error;
      widget.viewModel.editGoalDetails.clearResult();
      switch (errorResult.error) {
        case GoalClosedException():
          AppDialog.show(
            context: context,
            canPop: false,
            title: FaIcon(
              FontAwesomeIcons.circleInfo,
              color: Theme.of(context).colorScheme.primary,
              size: 30,
            ),
            content: Text(
              context.localization.goalsClosedGoalError,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            actions: AppFilledButton(
              label: context.localization.misc_goToHomepage,
              onPress: () {
                context.pop(); // Close dialog
                context.go(
                  Routes.goals(workspaceId: widget.viewModel.activeWorkspaceId),
                );
              },
            ),
          );
          break;
        default:
          AppSnackbar.showError(
            context: context,
            message: context.localization.goalsDetailsEditError,
          );
      }
    }
  }

  void _onGoalCloseResult() {
    if (widget.viewModel.closeGoal.completed) {
      widget.viewModel.closeGoal.clearResult();
      AppSnackbar.showSuccess(
        context: context,
        message: context.localization.goalsDetailsCloseSuccess,
      );
      context.pop(); // Close dialog
      context.pop(); // Navigate back to goals page
    }

    if (widget.viewModel.closeGoal.error) {
      final errorResult = widget.viewModel.closeGoal.result as Error;
      widget.viewModel.closeGoal.clearResult();
      switch (errorResult.error) {
        case GoalClosedException():
          AppSnackbar.showError(
            context: context,
            message: context.localization.goalsClosedGoalError,
          );
          break;
        default:
          AppSnackbar.showError(
            context: context,
            message: context.localization.goalsDetailsEditError,
          );
      }
    }
  }
}
