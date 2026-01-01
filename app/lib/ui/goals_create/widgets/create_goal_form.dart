import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../domain/constants/objective_rules.dart';
import '../../../domain/constants/validation_rules.dart';
import '../../../domain/models/workspace_user.dart';
import '../../core/l10n/l10n_extensions.dart';
import '../../core/ui/app_avatar.dart';
import '../../core/ui/app_filled_button.dart';
import '../../core/ui/app_select_field/app_select_field.dart';
import '../../core/ui/app_select_field/app_select_form_field.dart';
import '../../core/ui/app_text_field/app_text_form_field.dart';
import '../../core/utils/extensions.dart';
import '../../core/utils/user.dart';
import '../view_models/create_goal_screen_viewmodel.dart';
import 'workspace_user_accumulated_points.dart';

class CreateGoalForm extends StatefulWidget {
  const CreateGoalForm({super.key, required this.viewModel});

  final CreateGoalScreenViewmodel viewModel;

  @override
  State<CreateGoalForm> createState() => _CreateGoalFormState();
}

class _CreateGoalFormState extends State<CreateGoalForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _requiredPointsController =
      TextEditingController();
  final ValueNotifier<AppSelectFieldOption<WorkspaceUser>?>
  _selectedAssigneeNotifier = ValueNotifier(null);

  void _onAssigneeSelected(
    AppSelectFieldOption<WorkspaceUser> selectedOptions,
  ) {
    _selectedAssigneeNotifier.value = selectedOptions;
    widget.viewModel.loadWorkspaceUserAccumulatedPoints.execute(
      _selectedAssigneeNotifier.value!.value.id,
    );
  }

  void _onAssigneeCleared() {
    _selectedAssigneeNotifier.value = null;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _requiredPointsController.dispose();
    _selectedAssigneeNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final members = widget.viewModel.workspaceMembers.map((user) {
      final fullName = UserUtils.constructFullName(
        firstName: user.firstName,
        lastName: user.lastName,
      );
      return AppSelectFieldOption(
        label: fullName,
        value: user,
        leading: AppAvatar(
          hashString: user.id,
          firstName: user.firstName,
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
            label: context.localization.goalTitleLabel,
            validator: _validateTitle,
            textInputAction: TextInputAction.next,
            maxCharacterCount: ValidationRules.objectiveTitleMaxLength,
          ),
          const SizedBox(height: 10),
          AppTextFormField(
            controller: _descriptionController,
            label: context.localization.goalDescriptionLabel,
            validator: _validateDescription,
            maxLines: null,
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.next,
            required: false,
            minLines: 3,
            maxCharacterCount: ValidationRules.objectiveDescriptionMaxLength,
          ),
          const SizedBox(height: 10),
          ValueListenableBuilder(
            valueListenable: _selectedAssigneeNotifier,
            builder: (builderContext, selectedAssigneeValue, _) =>
                AppSelectFormField.single(
                  options: members,
                  value: selectedAssigneeValue,
                  onChanged: _onAssigneeSelected,
                  onCleared: _onAssigneeCleared,
                  label: builderContext.localization.objectiveAssigneeLabel,
                  validator: (assignee) =>
                      _validateAssignee(builderContext, assignee),
                ),
          ),
          ValueListenableBuilder(
            valueListenable: _selectedAssigneeNotifier,
            builder: (builderContext, selectedAssigneeValue, _) {
              if (_selectedAssigneeNotifier.value != null) {
                return Align(
                  alignment: Alignment.centerLeft,
                  child: WorkspaceUserAccumulatedPoints(
                    viewModel: widget.viewModel,
                    selectedAssignee: selectedAssigneeValue!.value,
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          const SizedBox(height: 10),
          AppTextFormField(
            controller: _requiredPointsController,
            label: context.localization.goalRequiredPointsLabel,
            validator: _validateRequiredPoints,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          const SizedBox(height: 20),
          ListenableBuilder(
            listenable: Listenable.merge([
              widget.viewModel.createGoal,
              _titleController,
              _requiredPointsController,
              _selectedAssigneeNotifier,
            ]),
            builder: (builderContext, _) {
              // Submit is enabled once title, required points
              // and selected assignee are not empty.
              final enabledSubmit =
                  _titleController.text.isNotEmpty &&
                  _requiredPointsController.text.isNotEmpty &&
                  _selectedAssigneeNotifier.value != null;

              return AppFilledButton(
                onPress: _onSubmit,
                label: builderContext.localization.goalCreateNew,
                loading: widget.viewModel.createGoal.running,
                disabled: !enabledSubmit,
              );
            },
          ),
        ],
      ),
    );
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      final title = _titleController.text.trim();
      final trimmedDescription = _descriptionController.text.trim();
      final description = trimmedDescription.nullIfEmpty;
      final requiredPoints = int.tryParse(
        _requiredPointsController.text.trim(),
      );
      final assignee = _selectedAssigneeNotifier.value!.value.id;

      if (requiredPoints == null) {
        // should be non-triggerable case, do something
        return;
      }

      widget.viewModel.createGoal.execute((
        title,
        description,
        assignee,
        requiredPoints,
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

  String? _validateAssignee(
    BuildContext context,
    List<AppSelectFieldOption>? assignee,
  ) {
    switch (assignee) {
      case final List<AppSelectFieldOption>? value when value == null:
      case final List<AppSelectFieldOption> value when value.isEmpty:
        return context.localization.goalAssigneesRequired;
      default:
        return null;
    }
  }

  String? _validateRequiredPoints(String? value) {
    final trimmedValue = value?.trim();
    final accumulatedPoints = widget.viewModel.workspaceUserAccumulatedPoints;

    switch (trimmedValue) {
      case final String trimmedValue when trimmedValue.isEmpty:
        return context.localization.misc_requiredField;
      case final String trimmedValue when int.tryParse(trimmedValue) == null:
        return context.localization.createNewGoalRequiredPointsNaN;
      case final String trimmedValue
          when int.tryParse(trimmedValue)! % ObjectiveRules.rewardPointsStep !=
              0:
        return context.localization.createNewGoalRequiredPointsNotMultipleOf10;
      case final String trimmedValue
          when accumulatedPoints != null &&
              int.tryParse(trimmedValue)! <= accumulatedPoints:
        return context
            .localization
            .createNewGoalRequiredPointsLowerThanAccumulatedPoints;
      default:
        return null;
    }
  }
}
