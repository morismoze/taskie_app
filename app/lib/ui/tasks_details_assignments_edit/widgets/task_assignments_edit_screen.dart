import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/constants/validation_rules.dart';
import '../../core/l10n/l10n_extensions.dart';
import '../../core/theme/dimens.dart';
import '../../core/ui/activity_indicator.dart';
import '../../core/ui/app_snackbar.dart';
import '../../core/ui/blurred_circles_background.dart';
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
    widget.viewModel.editTaskAssignments.addListener(
      _onTaskAssignmentsEditResult,
    );
    super.initState();
  }

  @override
  void didUpdateWidget(covariant TaskAssignmentsEditScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.viewModel.editTaskAssignments.removeListener(
      _onTaskAssignmentsEditResult,
    );
    widget.viewModel.editTaskAssignments.addListener(
      _onTaskAssignmentsEditResult,
    );
  }

  @override
  void dispose() {
    widget.viewModel.editTaskAssignments.removeListener(
      _onTaskAssignmentsEditResult,
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
              HeaderBar(title: context.localization.tasksAssignmentsEdit),
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
                              if (widget.viewModel.workspaceMembers.isEmpty ||
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

  void _onTaskAssignmentsEditResult() {
    if (widget.viewModel.editTaskAssignments.completed) {
      widget.viewModel.editTaskAssignments.clearResult();
      AppSnackbar.showSuccess(
        context: context,
        message: context.localization.tasksDetailsEditSuccess,
      );
      context.pop(); // Navigate back to tasks page
    }

    if (widget.viewModel.editTaskAssignments.error) {
      widget.viewModel.editTaskAssignments.clearResult();
      AppSnackbar.showError(
        context: context,
        message: context.localization.tasksDetailsEditError,
      );
    }
  }
}
