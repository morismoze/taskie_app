import 'package:flutter/material.dart';

import '../../../domain/constants/validation_rules.dart';
import '../../core/l10n/l10n_extensions.dart';
import '../../core/ui/app_avatar.dart';
import '../../core/ui/app_filled_button.dart';
import '../../core/ui/app_select_field/app_select_field.dart';
import '../../core/ui/app_select_field/app_select_form_field.dart';
import '../../core/utils/user.dart';
import '../view_models/task_assignments_edit_screen_view_model.dart';

class AddNewAssigneeForm extends StatefulWidget {
  const AddNewAssigneeForm({super.key, required this.viewModel});

  final TaskAssignmentsEditScreenViewModel viewModel;

  @override
  State<AddNewAssigneeForm> createState() => _AddNewAssigneeFormState();
}

class _AddNewAssigneeFormState extends State<AddNewAssigneeForm> {
  final _formKey = GlobalKey<FormState>();
  List<AppSelectFieldOption> options = [];
  List<String> _selectedAssigneeWorkspaceIds = [];

  @override
  void didChangeDependencies() {
    options = widget.viewModel.workspaceMembers.map((user) {
      final fullName = UserUtils.constructFullName(
        firstName: user.firstName,
        lastName: user.lastName,
      );
      return AppSelectFieldOption(
        label: fullName,
        value: user.id,
        leading: AppAvatar(
          hashString: user.id,
          firstName: user.firstName,
          imageUrl: user.profileImageUrl,
        ),
      );
    }).toList();
    super.didChangeDependencies();
  }

  void _onAssigneesSelected(List<AppSelectFieldOption> selectedOptions) {
    setState(() {
      // Take selected workspace IDs
      _selectedAssigneeWorkspaceIds = selectedOptions
          .map((option) => option.value as String)
          .toList();
    });
  }

  void _onAssigneesCleared() {
    setState(() {
      _selectedAssigneeWorkspaceIds = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 30,
      children: [
        Text(
          context.localization.tasksAssignmentsEditAddNewAssignee,
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
        ),
        Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUnfocus,
          child: Column(
            children: [
              const SizedBox(height: 10),
              AppSelectFormField(
                options: options,
                onSelected: _onAssigneesSelected,
                onCleared: _onAssigneesCleared,
                label: context.localization.objectiveAssigneeLabel,
                multiple: true,
                max:
                    ValidationRules.taskMaxAssigneesCount -
                    widget.viewModel.assignees!.length,
                validator: (assignees) =>
                    _validateAssignees(context, assignees),
              ),
              const SizedBox(height: 30),
              ListenableBuilder(
                listenable: widget.viewModel.editTaskDetails,
                builder: (builderContext, _) => AppFilledButton(
                  onPress: _onSubmit,
                  label: builderContext.localization.taskCreateNew,
                  loading: widget.viewModel.addNewAssignee.running,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      widget.viewModel.addNewAssignee.execute(_selectedAssigneeWorkspaceIds);
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
