import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../data/services/api/exceptions/task_assignees_already_exist_exception.dart';
import '../../../data/services/api/exceptions/task_assignees_count_maxed_out_exception.dart';
import '../../../data/services/api/exceptions/task_assignees_invalid_exception.dart';
import '../../../data/services/api/exceptions/task_closed_exception.dart';
import '../../../domain/constants/validation_rules.dart';
import '../../../routing/routes.dart';
import '../../../utils/command.dart';
import '../../core/l10n/l10n_extensions.dart';
import '../../core/theme/dimens.dart';
import '../../core/ui/activity_indicator.dart';
import '../../core/ui/app_dialog.dart';
import '../../core/ui/app_filled_button.dart';
import '../../core/ui/app_snackbar.dart';
import '../../core/ui/blurred_circles_background.dart';
import '../../core/ui/header_bar/app_header_action_button.dart';
import '../../core/ui/header_bar/header_bar.dart';
import '../../core/ui/separator.dart';
import '../view_models/task_assignments_edit_screen_view_model.dart';
import 'add_new_assignee_form.dart';
import 'edit_assignments_form.dart';

class TaskAssignmentsEditScreen extends StatefulWidget {
  const TaskAssignmentsEditScreen({super.key, required this.viewModel});

  final TaskAssignmentsEditScreenViewModel viewModel;

  @override
  State<TaskAssignmentsEditScreen> createState() =>
      _TaskAssignmentsEditScreenState();
}

class _TaskAssignmentsEditScreenState extends State<TaskAssignmentsEditScreen> {
  @override
  void initState() {
    widget.viewModel.addTaskAssignee.addListener(_onAddTaskAssigneeResult);
    widget.viewModel.removeTaskAssignee.addListener(
      _onRemoveTaskAssigneeResult,
    );
    widget.viewModel.updateTaskAssignments.addListener(
      _onUpdateTaskAssignmentsResult,
    );
    super.initState();
  }

  @override
  void didUpdateWidget(covariant TaskAssignmentsEditScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.viewModel.updateTaskAssignments.removeListener(
      _onAddTaskAssigneeResult,
    );
    oldWidget.viewModel.updateTaskAssignments.removeListener(
      _onRemoveTaskAssigneeResult,
    );
    oldWidget.viewModel.updateTaskAssignments.removeListener(
      _onUpdateTaskAssignmentsResult,
    );
    widget.viewModel.updateTaskAssignments.addListener(
      _onAddTaskAssigneeResult,
    );
    widget.viewModel.updateTaskAssignments.addListener(
      _onRemoveTaskAssigneeResult,
    );
    widget.viewModel.updateTaskAssignments.addListener(
      _onUpdateTaskAssignmentsResult,
    );
  }

  @override
  void dispose() {
    widget.viewModel.updateTaskAssignments.removeListener(
      _onAddTaskAssigneeResult,
    );
    widget.viewModel.updateTaskAssignments.removeListener(
      _onRemoveTaskAssigneeResult,
    );
    widget.viewModel.updateTaskAssignments.removeListener(
      _onUpdateTaskAssignmentsResult,
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlurredCirclesBackground(
        child: SafeArea(
          child: Column(
            children: [
              HeaderBar(
                title: context.localization.tasksAssignmentsEdit,
                actions: [
                  AppHeaderActionButton(
                    iconData: FontAwesomeIcons.question,
                    onTap: () {
                      if (widget.viewModel.taskId != null) {
                        context.push(
                          Routes.taskDetailsAssignmentsGuide(
                            workspaceId: widget.viewModel.activeWorkspaceId,
                            taskId: widget.viewModel.taskId!,
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimens.of(context).paddingScreenHorizontal,
                  ),
                  child: ListenableBuilder(
                    listenable: widget.viewModel,
                    builder: (builderContext, child) {
                      if (widget.viewModel.assignees == null) {
                        return ActivityIndicator(
                          radius: 16,
                          color: Theme.of(builderContext).colorScheme.primary,
                        );
                      }

                      return ListView(
                        padding: EdgeInsets.symmetric(
                          vertical: Dimens.of(context).paddingScreenVertical,
                        ),
                        children: [
                          EditAssignmentsForm(viewModel: widget.viewModel),
                          if (widget.viewModel.assignees!.length ==
                              ValidationRules.taskMaxAssigneesCount)
                            // The number of assignees is already maxed out
                            const SizedBox.shrink()
                          else
                            Column(
                              children: [
                                const SizedBox(height: 40),
                                const Separator(),
                                const SizedBox(height: 30),
                                AddNewAssigneeForm(viewModel: widget.viewModel),
                              ],
                            ),
                        ],
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

  void _onAddTaskAssigneeResult() {
    if (widget.viewModel.addTaskAssignee.completed) {
      widget.viewModel.addTaskAssignee.clearResult();
      AppSnackbar.showSuccess(
        context: context,
        message: context.localization.tasksAddTaskAssignmentSuccess,
      );
    }

    if (widget.viewModel.addTaskAssignee.error) {
      final errorResult = widget.viewModel.addTaskAssignee.result as Error;
      widget.viewModel.addTaskAssignee.clearResult();
      switch (errorResult.error) {
        case TaskClosedException():
          _showClosedTaskErrorDialog();
          break;
        case TaskAssigneesCountMaxedOutException():
        case TaskAssigneesAlreadyExistException():
          _showAssigneesWereAmendedErrorDialog();
          break;
        default:
          AppSnackbar.showError(
            context: context,
            message: context.localization.tasksAddTaskAssignmentError,
          );
      }
    }
  }

  void _onRemoveTaskAssigneeResult() {
    if (widget.viewModel.removeTaskAssignee.completed) {
      widget.viewModel.removeTaskAssignee.clearResult();
      AppSnackbar.showSuccess(
        context: context,
        message: context.localization.tasksRemoveTaskAssignmentSuccess,
      );
      context.pop(); // Close confirmation dialog
    }

    if (widget.viewModel.removeTaskAssignee.error) {
      context.pop(); // Close confirmation dialog
      final errorResult = widget.viewModel.removeTaskAssignee.result as Error;
      widget.viewModel.removeTaskAssignee.clearResult();
      switch (errorResult.error) {
        case TaskClosedException():
          _showClosedTaskErrorDialog();
          break;
        default:
          AppSnackbar.showError(
            context: context,
            message: context.localization.tasksRemoveTaskAssignmentError,
          );
      }
    }
  }

  void _onUpdateTaskAssignmentsResult() {
    if (widget.viewModel.updateTaskAssignments.completed) {
      widget.viewModel.updateTaskAssignments.clearResult();
      AppSnackbar.showSuccess(
        context: context,
        message: context.localization.tasksUpdateTaskAssignmentsSuccess,
      );
    }

    if (widget.viewModel.updateTaskAssignments.error) {
      final errorResult =
          widget.viewModel.updateTaskAssignments.result as Error;
      widget.viewModel.updateTaskAssignments.clearResult();
      switch (errorResult.error) {
        case TaskClosedException():
          _showClosedTaskErrorDialog();
          break;
        case TaskAssigneesInvalidException():
          _showAssigneesWereAmendedErrorDialog();
          break;
        default:
          AppSnackbar.showError(
            context: context,
            message: context.localization.tasksUpdateTaskAssignmentsUpdateError,
          );
      }
    }
  }

  void _showClosedTaskErrorDialog() {
    AppDialog.show(
      context: context,
      canPop: false,
      title: FaIcon(
        FontAwesomeIcons.circleInfo,
        color: Theme.of(context).colorScheme.primary,
        size: 30,
      ),
      content: Text(
        context.localization.tasksClosedTaskError,
        style: Theme.of(context).textTheme.bodyMedium,
        textAlign: TextAlign.center,
      ),
      actions: AppFilledButton(
        label: context.localization.misc_goToHomepage,
        onPress: () {
          context.pop(); // Close dialog
          context.go(
            Routes.tasks(workspaceId: widget.viewModel.activeWorkspaceId),
          );
        },
      ),
    );
  }

  void _showAssigneesWereAmendedErrorDialog() {
    AppDialog.show(
      context: context,
      canPop: false,
      title: FaIcon(
        FontAwesomeIcons.circleInfo,
        color: Theme.of(context).colorScheme.primary,
        size: 30,
      ),
      content: Text(
        context.localization.tasksAmendedAssigneesError,
        style: Theme.of(context).textTheme.bodyMedium,
        textAlign: TextAlign.center,
      ),
      actions: AppFilledButton(
        label: context.localization.misc_goToHomepage,
        onPress: () {
          context.pop(); // Close dialog
          context.go(
            Routes.tasks(workspaceId: widget.viewModel.activeWorkspaceId),
          );
        },
      ),
    );
  }
}
