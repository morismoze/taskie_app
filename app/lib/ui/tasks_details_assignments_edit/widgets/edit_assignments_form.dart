import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../data/services/api/workspace/progress_status.dart';
import '../../core/l10n/l10n_extensions.dart';
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
                onStatusChanged: _onStatusChanged,
                removeAssignee: _confirmAssigneeRemoval,
              );
            }
            return const SizedBox.shrink();
          }),
          const SizedBox(height: 20),
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
          onSubmit: (BuildContext builderContext) =>
              widget.viewModel.removeTaskAssignee.execute(assigneeId),
          onCancel: (BuildContext builderContext) =>
              Navigator.pop(builderContext),
          submitButtonText: (BuildContext builderContext) =>
              builderContext.localization.tasksRemoveTaskAssignmentModalCta,
          submitButtonColor: (BuildContext builderContext) =>
              Theme.of(builderContext).colorScheme.error,
        ),
      ],
    );
  }

  void _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      final assignments = _assigneesStatuses.entries
          .map((entry) => (entry.key, entry.value))
          .toList();
      widget.viewModel.updateTaskAssignments.execute(assignments);
    }
  }
}
