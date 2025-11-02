import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../data/services/api/workspace/progress_status.dart';
import '../../core/l10n/l10n_extensions.dart';
import '../../core/ui/app_dialog.dart';
import '../../core/ui/app_filled_button.dart';
import '../../core/ui/app_text_button.dart';
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

  void _initState() {
    for (final assignee in widget.viewModel.assignees!) {
      setState(() {
        _assigneesStatuses[assignee.id] = assignee.status;
      });
    }
  }

  @override
  void initState() {
    _initState();
    super.initState();
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
            return TaskAssignmentFormField(
              assigneeId: assignee.id,
              firstName: assignee.firstName,
              lastName: assignee.lastName,
              profileImageUrl: assignee.profileImageUrl,
              status: _assigneesStatuses[assignee.id]!,
              onStatusChanged: _onStatusChanged,
              removeAssignee: _confirmAssigneeRemoval,
            );
          }),
          const SizedBox(height: 20),
          ListenableBuilder(
            listenable: widget.viewModel.updateTaskAssignments,
            builder: (builderContext, _) => AppFilledButton(
              onPress: _onSubmit,
              label:
                  builderContext.localization.tasksAssignmentsEditStatusSubmit,
              loading: widget.viewModel.updateTaskAssignments.running,
            ),
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
        context.localization.removeTaskAssignmentModalMessage,
        style: Theme.of(context).textTheme.bodyMedium,
        textAlign: TextAlign.center,
      ),
      actions: [
        ListenableBuilder(
          listenable: widget.viewModel.removeTaskAssignee,
          builder: (BuildContext builderContext, _) => AppFilledButton(
            label: builderContext.localization.removeTaskAssignmentModalCta,
            onPress: () =>
                widget.viewModel.removeTaskAssignee.execute(assigneeId),
            backgroundColor: Theme.of(builderContext).colorScheme.error,
            loading: widget.viewModel.removeTaskAssignee.running,
          ),
        ),
        ListenableBuilder(
          listenable: widget.viewModel.removeTaskAssignee,
          builder: (BuildContext builderContext, _) => AppTextButton(
            disabled: widget.viewModel.removeTaskAssignee.running,
            label: builderContext.localization.misc_cancel,
            onPress: () => Navigator.pop(builderContext),
          ),
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
