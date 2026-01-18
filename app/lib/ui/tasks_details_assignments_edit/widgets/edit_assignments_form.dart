import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../data/services/api/workspace/progress_status.dart';
import '../../core/l10n/l10n_extensions.dart';
import '../../core/theme/dimens.dart';
import '../../core/ui/action_button_bar.dart';
import '../../core/ui/app_dialog.dart';
import '../../core/ui/app_filled_button.dart';
import '../view_models/task_assignments_edit_screen_view_model.dart';
import 'task_assignment_form_field.dart';

class EditAssignmentsForm extends StatefulWidget {
  const EditAssignmentsForm({super.key, required this.viewModel});

  final TaskAssignmentsEditScreenViewModel viewModel;

  @override
  State<EditAssignmentsForm> createState() => _EditAssignmentsFormState();
}

class _EditAssignmentsFormState extends State<EditAssignmentsForm> {
  final _formKey = GlobalKey<FormState>();
  // Status per workspace user ID
  final Map<String, ProgressStatus> _assigneesStatuses = {};
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    for (final assignee in widget.viewModel.assignees!) {
      _assigneesStatuses[assignee.id] = assignee.status;
    }
  }

  @override
  void didUpdateWidget(covariant EditAssignmentsForm oldWidget) {
    super.didUpdateWidget(oldWidget);

    final newStatusesMap = <String, ProgressStatus>{};

    // This logic is needed because on the same screen user can add a
    // new assignee, so we need to listen on that, and update local state.
    for (final assignee in widget.viewModel.assignees!) {
      if (_assigneesStatuses.containsKey(assignee.id)) {
        // Keep current status which may have been modified by the Manager
        newStatusesMap[assignee.id] = _assigneesStatuses[assignee.id]!;
      } else {
        newStatusesMap[assignee.id] = assignee.status;
      }
    }

    setState(() {
      _assigneesStatuses.clear();
      _assigneesStatuses.addAll(newStatusesMap);
    });
  }

  void _onStatusChanged(String workspaceUserId, ProgressStatus status) {
    setState(() {
      _assigneesStatuses[workspaceUserId] = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          ...widget.viewModel.assignees!.map((assignee) {
            if (_assigneesStatuses[assignee.id] != null) {
              return TaskAssignmentFormField(
                assigneeId: assignee.id,
                firstName: assignee.firstName,
                lastName: assignee.lastName,
                profileImageUrl: assignee.profileImageUrl,
                status: _assigneesStatuses[assignee.id]!,
                dueDate: widget.viewModel.dueDate,
                onStatusChanged: _onStatusChanged,
                removeAssignee: _confirmAssigneeRemoval,
              );
            }
            return const SizedBox.shrink();
          }),
          if (_errorMessage != null) ...[
            Text(
              _errorMessage!,
              style:
                  Theme.of(context).inputDecorationTheme.errorStyle ??
                  Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
            ),
            const SizedBox(height: Dimens.paddingVertical / 1.2),
          ] else
            const SizedBox(height: Dimens.paddingVertical / 1.2),
          ListenableBuilder(
            listenable: widget.viewModel.updateTaskAssignments,
            builder: (builderContext, _) {
              var dirty = false;

              for (final assignee in widget.viewModel.assignees!) {
                if (_assigneesStatuses[assignee.id] != assignee.status) {
                  dirty = true;
                  break;
                }
              }

              return AppFilledButton(
                onPress: _onSubmit,
                label: builderContext
                    .localization
                    .tasksAssignmentsEditStatusSubmit,
                loading: widget.viewModel.updateTaskAssignments.running,
                disabled: !dirty,
              );
            },
          ),
        ],
      ),
    );
  }

  void _confirmAssigneeRemoval(String assigneeId) {
    AppDialog.showAlert(
      context: context,
      canPop: !widget.viewModel.removeTaskAssignee.running,
      title: FaIcon(
        FontAwesomeIcons.circleExclamation,
        color: Theme.of(context).colorScheme.error,
        size: 30,
      ),
      content: Text(
        context.localization.tasksRemoveTaskAssignmentModalMessage,
        style: Theme.of(context).textTheme.bodyMedium,
        textAlign: TextAlign.center,
      ),
      actions: [
        ActionButtonBar.withCommand(
          command: widget.viewModel.removeTaskAssignee,
          onSubmit: () =>
              widget.viewModel.removeTaskAssignee.execute(assigneeId),
          onCancel: () => context.pop(),
          submitButtonText:
              context.localization.tasksRemoveTaskAssignmentModalCta,
          submitButtonColor: Theme.of(context).colorScheme.error,
        ),
      ],
    );
  }

  void _onSubmit() {
    setState(() {
      _errorMessage = null;
    });

    if (_formKey.currentState!.validate()) {
      // Check if there is any updated status set to
      // Completed, even though it should be set to
      // Completed as Stale, in the case task has
      // due date and which has passed. This is an
      // edge case which can happen e.g. if user set
      // the the Completed status to one or more
      // assignments before the due date and submitted
      // tried to submit the form on the day after due
      // date - it's a stretch, but a real edge case.
      // We also have a check on the backend for this.
      final now = DateTime.now();
      final isTaskPastDueDate =
          widget.viewModel.dueDate != null &&
          widget.viewModel.dueDate!.isBefore(now);
      final firstCompletedTask = _assigneesStatuses.entries.firstWhereOrNull(
        (assignment) => assignment.value == ProgressStatus.completed,
      );
      if (isTaskPastDueDate && firstCompletedTask != null) {
        setState(() {
          _errorMessage =
              context.localization.tasksAssignmentsEditStatusDueDateError;
        });
        return;
      }

      final assignments = _assigneesStatuses.entries
          .map((entry) => (entry.key, entry.value))
          .toList();
      widget.viewModel.updateTaskAssignments.execute(assignments);
    }
  }
}
