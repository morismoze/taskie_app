import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/constants/objective_rules.dart';
import '../../../domain/constants/validation_rules.dart';
import '../../core/l10n/l10n_extensions.dart';
import '../../core/ui/app_avatar.dart';
import '../../core/ui/app_date_picker_field/app_date_picker_form_field.dart';
import '../../core/ui/app_filled_button.dart';
import '../../core/ui/app_select_field/app_select_field.dart';
import '../../core/ui/app_select_field/app_select_form_field.dart';
import '../../core/ui/app_slider_field/app_slider_form_field.dart';
import '../../core/ui/app_snackbar.dart';
import '../../core/ui/app_text_form_field.dart';
import '../view_models/create_task_viewmodel.dart';

class CreateTaskForm extends StatefulWidget {
  const CreateTaskForm({super.key, required this.viewModel});

  final CreateTaskViewmodel viewModel;

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

  @override
  void initState() {
    super.initState();
    widget.viewModel.createTask.addListener(_onResult);
  }

  @override
  void didUpdateWidget(covariant CreateTaskForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.viewModel.createTask.removeListener(_onResult);
    widget.viewModel.createTask.addListener(_onResult);
  }

  @override
  void dispose() {
    widget.viewModel.createTask.removeListener(_onResult);
    super.dispose();
  }

  void _onAssigneesSelected(List<AppSelectFieldOption> selectedOptions) {
    setState(() {
      // Take selected workspace IDs
      _selectedAssigneeWorkspaceIds = selectedOptions
          .map((option) => option.value)
          .toList();
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

  @override
  Widget build(BuildContext context) {
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
            maxCharacterCount: ValidationRules.taskTitleMaxLength,
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
            maxCharacterCount: ValidationRules.taskDescriptionMaxLength,
          ),
          const SizedBox(height: 10),
          ListenableBuilder(
            listenable: widget.viewModel,
            builder: (builderContext, _) {
              final options = widget.viewModel.workspaceUsers.map((user) {
                final fullName = '${user.firstName} ${user.lastName}';
                return AppSelectFieldOption(
                  label: fullName,
                  value: user.id,
                  leading: AppAvatar(
                    text: fullName,
                    imageUrl: user.profileImageUrl,
                  ),
                );
              }).toList();

              return AppSelectFormField(
                options: options,
                onSelected: _onAssigneesSelected,
                label: context.localization.taskAssigneeLabel,
                multiple: true,
                validator: _validateAssignees,
              );
            },
          ),
          const SizedBox(height: 10),
          AppDatePickerFormField(
            onSelected: _onDueDateSelected,
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
              label: context.localization.taskCreateNew,
              isLoading: widget.viewModel.createTask.running,
            ),
          ),
        ],
      ),
    );
  }

  void _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      final title = _titleController.text;
      final description = _descriptionController.text;
      final iso8601DateString = _dueDate?.toIso8601String();

      widget.viewModel.createTask.execute((
        title,
        description,
        _selectedAssigneeWorkspaceIds,
        _rewardPoints,
        iso8601DateString,
      ));
    }
  }

  String? _validateTitle(String? value) {
    switch (value) {
      case final String? value when value == null:
        return context.localization.requiredField;
      case final String value
          when value.length < ValidationRules.taskTitleMinLength:
        return context.localization.taskTitleMinLength;
      case final String value
          when value.length > ValidationRules.taskTitleMaxLength:
        return context.localization.taskTitleMaxLength;
      default:
        return null;
    }
  }

  String? _validateDescription(String? value) {
    switch (value) {
      case final String value
          when value.length > ValidationRules.taskDescriptionMaxLength:
        return context.localization.taskDescriptionMaxLength;
      default:
        return null;
    }
  }

  String? _validateAssignees(List<AppSelectFieldOption>? assignees) {
    switch (assignees) {
      case final String? value when value == null:
        return context.localization.requiredField;
      case final List<AppSelectFieldOption> value
          when value.length < ValidationRules.taskMinAssigneesCount:
        return context.localization.taskAssigneesMinLength;
      default:
        return null;
    }
  }

  void _onResult() {
    if (widget.viewModel.createTask.completed) {
      widget.viewModel.createTask.clearResult();
      context.pop();
    }

    if (widget.viewModel.createTask.error) {
      AppSnackbar.showError(
        context: context,
        message: context.localization.somethingWentWrong,
      );

      widget.viewModel.createTask.clearResult();
    }
  }
}
