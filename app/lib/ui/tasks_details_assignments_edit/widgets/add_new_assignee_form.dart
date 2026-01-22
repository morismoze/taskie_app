import 'package:flutter/material.dart';

import '../../../domain/constants/validation_rules.dart';
import '../../../domain/models/interfaces/user_interface.dart';
import '../../../domain/models/workspace_user.dart';
import '../../core/l10n/l10n_extensions.dart';
import '../../core/theme/dimens.dart';
import '../../core/ui/app_avatar.dart';
import '../../core/ui/app_filled_button.dart';
import '../../core/ui/app_select_field/app_select_field.dart';
import '../../core/ui/app_select_field/app_select_form_field.dart';
import '../view_models/task_assignments_edit_screen_view_model.dart';

class AddNewAssigneeForm extends StatefulWidget {
  const AddNewAssigneeForm({super.key, required this.viewModel});

  final TaskAssignmentsEditScreenViewModel viewModel;

  @override
  State<AddNewAssigneeForm> createState() => _AddNewAssigneeFormState();
}

class _AddNewAssigneeFormState extends State<AddNewAssigneeForm> {
  final _formKey = GlobalKey<FormState>();
  List<AppSelectFieldOption<WorkspaceUser>> options = [];
  // ValueNotifier is not needed here because we use setState
  // which rebuild the whole widget and this is a simple widget
  // so no need for serparate ValueListenableBuilder.
  List<AppSelectFieldOption<WorkspaceUser>> _selectedAssignees = [];

  @override
  void initState() {
    super.initState();
    // Doesn't need setState because widget is not yet built
    // meaning build() method is not yet invoked
    _updateOptions();
  }

  @override
  void didUpdateWidget(covariant AddNewAssigneeForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Needs setState because widget is already built and needs rebuild
    setState(() {
      _updateOptions();
    });
  }

  void _updateOptions() {
    options = widget.viewModel.workspaceMembersNotAssigned.map((user) {
      return AppSelectFieldOption<WorkspaceUser>(
        label: user.fullName,
        value: user,
        leading: AppAvatar(
          hashString: user.id,
          firstName: user.firstName,
          imageUrl: user.profileImageUrl,
        ),
      );
    }).toList();
  }

  void _onAssigneesSelected(
    List<AppSelectFieldOption<WorkspaceUser>> selectedOptions,
  ) {
    setState(() {
      _selectedAssignees = selectedOptions;
    });
  }

  void _onAssigneesCleared() {
    setState(() {
      _selectedAssignees = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUnfocus,
      child: Column(
        children: [
          AppSelectFormField(
            options: options,
            value: _selectedAssignees,
            onChanged: _onAssigneesSelected,
            onCleared: _onAssigneesCleared,
            label: context.localization.objectiveAssigneeLabel,
            multiple: true,
            max:
                ValidationRules.taskMaxAssigneesCount -
                widget.viewModel.assignees!.length,
            validator: (assignees) => _validateAssignees(context, assignees),
          ),
          const SizedBox(height: Dimens.paddingVertical / 1.2),
          ListenableBuilder(
            listenable: widget.viewModel.addTaskAssignee,
            builder: (builderContext, _) {
              final isDirty = _selectedAssignees.isNotEmpty;

              return AppFilledButton(
                onPress: _onSubmit,
                label: builderContext.localization.objectiveAssigneeLabel,
                loading: widget.viewModel.addTaskAssignee.running,
                disabled: !isDirty,
              );
            },
          ),
        ],
      ),
    );
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      final assigneeIds = _selectedAssignees
          .map((assignee) => assignee.value.id)
          .toList();
      widget.viewModel.addTaskAssignee.execute(assigneeIds);
      _selectedAssignees.clear();
    }
  }

  String? _validateAssignees(
    BuildContext context,
    List<AppSelectFieldOption>? assignees,
  ) {
    switch (assignees) {
      case final List<AppSelectFieldOption>? value when value == null:
      case final List<AppSelectFieldOption> value
          when value.length < ValidationRules.objectiveMinAssigneesCount:
        return context.localization.taskAssigneesMinLength;
      default:
        return null;
    }
  }
}
