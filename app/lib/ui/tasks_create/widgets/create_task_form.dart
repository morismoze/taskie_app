import 'package:flutter/material.dart';

import '../../../domain/constants/objective_rules.dart';
import '../../../domain/constants/validation_rules.dart';
import '../../core/l10n/l10n_extensions.dart';
import '../../core/ui/app_avatar.dart';
import '../../core/ui/app_date_picker_field/app_date_picker_form_field.dart';
import '../../core/ui/app_filled_button.dart';
import '../../core/ui/app_select_field/app_select_field.dart';
import '../../core/ui/app_select_field/app_select_form_field.dart';
import '../../core/ui/app_slider_field/app_slider_form_field.dart';
import '../../core/ui/app_text_field/app_text_form_field.dart';
import '../view_models/create_task_screen_viewmodel.dart';

class CreateTaskForm extends StatefulWidget {
  const CreateTaskForm({super.key, required this.viewModel});

  final CreateTaskScreenViewmodel viewModel;

  @override
  State<CreateTaskForm> createState() => _CreateTaskFormState();
}

class _CreateTaskFormState extends State<CreateTaskForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  List<String> _selectedAssigneeWorkspaceIds = [];
  int _rewardPoints = ObjectiveRules.rewardPointsMin;
  DateTime? _dueDate;

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

  void _onRewardPointsChanged(double points) {
    setState(() {
      _rewardPoints = points.toInt();
    });
  }

  void _onDueDateSelected(DateTime date) {
    setState(() {
      _dueDate = date;
    });
  }

  void _onDueDateCleared() {
    setState(() {
      _dueDate = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final options = widget.viewModel.workspaceMembers.map((user) {
      final fullName = '${user.firstName} ${user.lastName}';
      return AppSelectFieldOption(
        label: fullName,
        value: user.id,
        leading: AppAvatar(
          hashString: user.id,
          fullName: fullName,
          imageUrl: user.profileImageUrl,
        ),
      );
    }).toList();

    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUnfocus,
      child: Column(
        children: [
          AppTextFormField(
            controller: _titleController,
            label: context.localization.taskTitleLabel,
            validator: _validateTitle,
            textInputAction: TextInputAction.next,
            maxCharacterCount: ValidationRules.objectiveTitleMaxLength,
          ),
          const SizedBox(height: 10),
          AppTextFormField(
            controller: _descriptionController,
            label: context.localization.taskDescriptionLabel,
            validator: _validateDescription,
            maxLines: null,
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.next,
            required: false,
            minLines: 3,
            maxCharacterCount: ValidationRules.objectiveDescriptionMaxLength,
          ),
          const SizedBox(height: 10),
          AppSelectFormField(
            options: options,
            onSelected: _onAssigneesSelected,
            onCleared: _onAssigneesCleared,
            label: context.localization.objectiveAssigneeLabel,
            multiple: true,
            max: ValidationRules.taskMaxAssigneesCount,
            validator: (assignees) => _validateAssignees(context, assignees),
          ),
          const SizedBox(height: 10),
          AppDatePickerFormField(
            onSelected: _onDueDateSelected,
            onCleared: _onDueDateCleared,
            label: context.localization.taskDueDateLabel,
            required: false,
            minimumDate: DateTime.now(),
          ),
          const SizedBox(height: 20),
          AppSliderFormField(
            label: context.localization.taskRewardPointsLabel,
            value: _rewardPoints.toDouble(),
            onChanged: _onRewardPointsChanged,
            step: ObjectiveRules.rewardPointsStep,
            min: ObjectiveRules.rewardPointsMin.toDouble(),
            max: ObjectiveRules.rewardPointsMax.toDouble(),
          ),
          const SizedBox(height: 30),
          ListenableBuilder(
            listenable: widget.viewModel.createTask,
            builder: (builderContext, _) => AppFilledButton(
              onPress: _onSubmit,
              label: builderContext.localization.taskCreateNew,
              isLoading: widget.viewModel.createTask.running,
            ),
          ),
        ],
      ),
    );
  }

  void _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      final title = _titleController.text.trim();
      final trimmedDescription = _descriptionController.text.trim();
      final description = trimmedDescription.isNotEmpty
          ? trimmedDescription
          : null;

      widget.viewModel.createTask.execute((
        title,
        description,
        _selectedAssigneeWorkspaceIds,
        _rewardPoints,
        _dueDate,
      ));
    }
  }

  String? _validateTitle(String? value) {
    final trimmedValue = value?.trim();
    switch (trimmedValue) {
      case final String trimmedValue when trimmedValue.isEmpty:
        return context.localization.misc_requiredField;
      case final String trimmedValue
          when trimmedValue.length < ValidationRules.objectiveTitleMinLength:
        return context.localization.objectiveTitleMinLength;
      case final String trimmedValue
          when trimmedValue.length > ValidationRules.objectiveTitleMaxLength:
        return context.localization.objectiveTitleMaxLength;
      default:
        return null;
    }
  }

  String? _validateDescription(String? value) {
    final trimmedValue = value?.trim();
    switch (trimmedValue) {
      case final String trimmedValue
          when trimmedValue.length >
              ValidationRules.objectiveDescriptionMaxLength:
        return context.localization.objectiveDescriptionMaxLength;
      default:
        return null;
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
