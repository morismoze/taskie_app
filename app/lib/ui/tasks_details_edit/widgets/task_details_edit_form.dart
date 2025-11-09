import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/constants/objective_rules.dart';
import '../../../domain/constants/validation_rules.dart';
import '../../../routing/routes.dart';
import '../../core/l10n/l10n_extensions.dart';
import '../../core/theme/colors.dart';
import '../../core/ui/app_date_picker_field/app_date_picker_form_field.dart';
import '../../core/ui/app_filled_button.dart';
import '../../core/ui/app_select_field/app_select_field.dart';
import '../../core/ui/app_select_field/app_select_field_selected_options.dart';
import '../../core/ui/app_slider_field/app_slider_form_field.dart';
import '../../core/ui/app_text_field/app_text_form_field.dart';
import '../../core/utils/extensions.dart';
import '../../core/utils/user.dart';
import '../view_models/task_details_edit_screen_view_model.dart';

class TaskDetailsEditForm extends StatefulWidget {
  const TaskDetailsEditForm({super.key, required this.viewModel});

  final TaskDetailsEditScreenViewModel viewModel;

  @override
  State<TaskDetailsEditForm> createState() => _TaskDetailsEditFormState();
}

class _TaskDetailsEditFormState extends State<TaskDetailsEditForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  late ValueNotifier<int> _rewardPointsNotifier;
  late ValueNotifier<DateTime?> _dueDateNotifier;

  @override
  void initState() {
    _titleController.text = widget.viewModel.details!.title;
    _descriptionController.text = widget.viewModel.details!.description ?? '';
    _rewardPointsNotifier = ValueNotifier(
      widget.viewModel.details!.rewardPoints,
    );
    _dueDateNotifier = ValueNotifier(widget.viewModel.details!.dueDate);
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _onRewardPointsChanged(double points) {
    setState(() {
      _rewardPointsNotifier.value = points.toInt();
    });
  }

  void _onDueDateSelected(DateTime date) {
    setState(() {
      _dueDateNotifier.value = date;
    });
  }

  void _onDueDateCleared() {
    setState(() {
      _dueDateNotifier.value = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedOptions = widget.viewModel.details!.assignees.map((assignee) {
      final fullName = UserUtils.constructFullName(
        firstName: assignee.firstName,
        lastName: assignee.lastName,
      );
      return AppSelectFieldOption(label: fullName, value: assignee.id);
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
          AppSelectFieldSelectedOptions(
            label: context.localization.objectiveAssigneeLabel,
            selectedOptions: selectedOptions,
            isFieldFocused: true,
            onTap: () => context.push(
              Routes.taskDetailsAssignmentsEdit(
                workspaceId: widget.viewModel.activeWorkspaceId,
                taskId: widget.viewModel.details!.id,
              ),
            ),
            enabled: true,
            required: true,
            trailing: const FaIcon(
              FontAwesomeIcons.sort,
              color: AppColors.black1,
              size: 17,
            ),
          ),
          const SizedBox(height: 30),
          ValueListenableBuilder(
            valueListenable: _dueDateNotifier,
            builder: (builderContext, dateValue, _) => AppDatePickerFormField(
              onSelected: _onDueDateSelected,
              onCleared: _onDueDateCleared,
              label: builderContext.localization.taskDueDateLabel,
              required: false,
              minimumDate: DateTime.now(),
              initialValue: dateValue,
            ),
          ),
          const SizedBox(height: 20),
          ValueListenableBuilder(
            valueListenable: _rewardPointsNotifier,
            builder: (builderContext, rewardPointsValue, _) =>
                AppSliderFormField(
                  label: builderContext.localization.taskRewardPointsLabel,
                  value: rewardPointsValue.toDouble(),
                  onChanged: _onRewardPointsChanged,
                  step: ObjectiveRules.rewardPointsStep,
                  min: ObjectiveRules.rewardPointsMin.toDouble(),
                  max: ObjectiveRules.rewardPointsMax.toDouble(),
                ),
          ),
          const SizedBox(height: 30),
          ListenableBuilder(
            listenable: Listenable.merge([
              widget.viewModel.editTaskDetails,
              _titleController,
              _descriptionController,
              _rewardPointsNotifier,
              _dueDateNotifier,
            ]),
            builder: (builderContext, _) {
              final dirty =
                  _titleController.text != widget.viewModel.details!.title ||
                  _descriptionController.text.nullIfEmpty !=
                      widget.viewModel.details!.description ||
                  _rewardPointsNotifier.value !=
                      widget.viewModel.details!.rewardPoints ||
                  _dueDateNotifier.value != widget.viewModel.details!.dueDate;

              return AppFilledButton(
                onPress: _onSubmit,
                label: builderContext.localization.editDetailsSubmit,
                loading: widget.viewModel.editTaskDetails.running,
                disabled: !dirty,
              );
            },
          ),
        ],
      ),
    );
  }

  void _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      final title = _titleController.text.trim();
      final trimmedDescription = _descriptionController.text.trim();
      final description = trimmedDescription.nullIfEmpty;

      widget.viewModel.editTaskDetails.execute((
        title,
        description,
        _rewardPointsNotifier.value,
        _dueDateNotifier.value,
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
}
