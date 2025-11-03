import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/constants/validation_rules.dart';
import '../../../routing/routes.dart';
import '../../core/l10n/l10n_extensions.dart';
import '../../core/theme/dimens.dart';
import '../../core/ui/activity_indicator.dart';
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
                  padding: EdgeInsets.only(
                    left: Dimens.of(context).paddingScreenHorizontal,
                    right: Dimens.of(context).paddingScreenHorizontal,
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
                        padding: const EdgeInsets.symmetric(
                          vertical: Dimens.paddingVertical,
                        ),
                        children: [
                          EditAssignmentsForm(viewModel: widget.viewModel),
                          ListenableBuilder(
                            listenable: widget.viewModel,
                            builder: (builderContext, _) {
                              if (widget
                                      .viewModel
                                      .workspaceMembersNotAssigned
                                      .isEmpty ||
                                  widget.viewModel.assignees!.length ==
                                      ValidationRules.taskMaxAssigneesCount) {
                                // Either all the workspace members are assigned to this task
                                // or the number of assignees is already maxed out.
                                return const SizedBox.shrink();
                              }

                              return Column(
                                children: [
                                  const SizedBox(height: 40),
                                  const Separator(),
                                  const SizedBox(height: 30),
                                  AddNewAssigneeForm(
                                    viewModel: widget.viewModel,
                                  ),
                                ],
                              );
                            },
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
        message: context.localization.addTaskAssignmentSuccess,
      );
    }

    if (widget.viewModel.addTaskAssignee.error) {
      widget.viewModel.addTaskAssignee.clearResult();
      AppSnackbar.showError(
        context: context,
        message: context.localization.addTaskAssignmentError,
      );
    }
  }

  void _onRemoveTaskAssigneeResult() {
    if (widget.viewModel.removeTaskAssignee.completed) {
      widget.viewModel.removeTaskAssignee.clearResult();
      AppSnackbar.showSuccess(
        context: context,
        message: context.localization.removeTaskAssignmentSuccess,
      );
      context.pop(); // Close confirmation dialog
    }

    if (widget.viewModel.removeTaskAssignee.error) {
      widget.viewModel.removeTaskAssignee.clearResult();
      AppSnackbar.showError(
        context: context,
        message: context.localization.removeTaskAssignmentError,
      );
    }
  }

  void _onUpdateTaskAssignmentsResult() {
    if (widget.viewModel.updateTaskAssignments.completed) {
      widget.viewModel.updateTaskAssignments.clearResult();
      AppSnackbar.showSuccess(
        context: context,
        message: context.localization.updateTaskAssignmentsSuccess,
      );
    }

    if (widget.viewModel.updateTaskAssignments.error) {
      widget.viewModel.updateTaskAssignments.clearResult();
      AppSnackbar.showError(
        context: context,
        message: context.localization.updateTaskAssignmentsUpdateError,
      );
    }
  }
}
