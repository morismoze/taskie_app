import 'package:flutter/material.dart';

import '../../../data/services/api/workspace/progress_status.dart';
import '../../core/l10n/l10n_extensions.dart';
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

  void _removeAssignee(String workspaceUserId) {
    setState(() {
      _assigneesStatuses.remove(workspaceUserId);
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
              removeAssignee: _removeAssignee,
            );
          }),
          const SizedBox(height: 20),
          ListenableBuilder(
            listenable: widget.viewModel.editTaskAssignments,
            builder: (builderContext, _) => AppFilledButton(
              onPress: _onSubmit,
              label:
                  builderContext.localization.tasksAssignmentsEditStatusSubmit,
              loading: widget.viewModel.editTaskAssignments.running,
            ),
          ),
        ],
      ),
    );
  }

  void _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      final assignments = _assigneesStatuses.entries
          .map((entry) => (entry.key, entry.value))
          .toList();
      widget.viewModel.editTaskAssignments.execute(assignments);
    }
  }
}
