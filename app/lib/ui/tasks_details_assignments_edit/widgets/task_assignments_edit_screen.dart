import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../data/services/api/api_response.dart';
import '../../../data/services/api/exceptions/general_api_exception.dart';
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
    super.initState();
    widget.viewModel.addTaskAssignee.addListener(_onAddTaskAssigneeResult);
    widget.viewModel.removeTaskAssignee.addListener(
      _onRemoveTaskAssigneeResult,
    );
    widget.viewModel.updateTaskAssignments.addListener(
      _onUpdateTaskAssignmentsResult,
    );
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
                          Routes.tasksGuide(
                            workspaceId: widget.viewModel.activeWorkspaceId,
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
                          if (widget.viewModel.assignees!.isEmpty)
                            Text(
                              context.localization.tasksAssignmentsEmpty,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleSmall!
                                  .copyWith(fontStyle: FontStyle.italic),
                            )
                          else
                            EditAssignmentsForm(viewModel: widget.viewModel),
                          Column(
                            children: [
                              const SizedBox(height: 40),
                              const Separator(),
                              const SizedBox(height: 30),
                              Text(
                                context
                                    .localization
                                    .tasksAssignmentsEditAddNewAssignee,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.titleMedium!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 30),
                              if (widget.viewModel.assignees!.length ==
                                  ValidationRules.taskMaxAssigneesCount) ...[
                                // The number of assignees is already maxed out
                                Text(
                                  context
                                      .localization
                                      .tasksAssignmentsEditAddNewAssigneeMaxedOutAssignees,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.titleSmall!
                                      .copyWith(fontStyle: FontStyle.italic),
                                ),
                              ] else if (widget
                                  .viewModel
                                  .workspaceMembersNotAssigned
                                  .isEmpty) ...[
                                // The number of assignees is already maxed out
                                Text(
                                  context
                                      .localization
                                      .tasksAssignmentsEditAddNewAssigneeEmptyAssignees,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.titleSmall!
                                      .copyWith(fontStyle: FontStyle.italic),
                                ),
                              ] else ...[
                                AddNewAssigneeForm(viewModel: widget.viewModel),
                              ],
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
        case GeneralApiException(error: final apiError)
            when apiError.code == ApiErrorCode.taskClosed:
          _showClosedTaskErrorDialog();
          break;
        case GeneralApiException(error: final apiError)
            when apiError.code == ApiErrorCode.taskAssigneesCountMaxedOut:
        case GeneralApiException(error: final apiError)
            when apiError.code == ApiErrorCode.taskAssigneesAlreadyExist:
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
        case GeneralApiException(error: final apiError)
            when apiError.code == ApiErrorCode.taskClosed:
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
        case GeneralApiException(error: final apiError)
            when apiError.code == ApiErrorCode.taskClosed:
          _showClosedTaskErrorDialog();
          break;
        // This exception is used when there was an attempt at
        // updating a task's assignments, but the task one or
        // more assignees was removed in the meanwhile (e.g.
        // by another Manager).
        case GeneralApiException(error: final apiError)
            when apiError.code == ApiErrorCode.taskAssigneesInvalid:
          _showAssigneesWereAmendedErrorDialog();
          break;
        // This exception is used when there was an attempt at adding updating status/es of a
        // task's assignments to Completed status, but the task's due date has passed. When
        // due date passes, only Completed as Stale is acceptable, not Completed.
        case GeneralApiException(error: final apiError)
            when apiError.code ==
                ApiErrorCode.taskAssignmentsCompletedStatusDueDatePassed:
          _showCompletedStatusDueDatePassedErrorDialog();
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

  void _showCompletedStatusDueDatePassedErrorDialog() {
    AppDialog.show(
      context: context,
      canPop: false,
      title: FaIcon(
        FontAwesomeIcons.circleInfo,
        color: Theme.of(context).colorScheme.primary,
        size: 30,
      ),
      content: Text(
        context.localization.tasksAssigmentsCompletedStatusDueDatePassedError,
        style: Theme.of(context).textTheme.bodyMedium,
        textAlign: TextAlign.center,
      ),
      actions: AppFilledButton(
        label: context.localization.misc_ok,
        onPress: () {
          context.pop(); // Close dialog
        },
      ),
    );
  }
}
