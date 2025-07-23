import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../domain/constants/objective_rules.dart';
import '../../../domain/constants/validation_rules.dart';
import '../../core/l10n/l10n_extensions.dart';
import '../../core/ui/app_avatar.dart';
import '../../core/ui/app_filled_button.dart';
import '../../core/ui/app_select_field/app_select_field.dart';
import '../../core/ui/app_select_field/app_select_form_field.dart';
import '../../core/ui/app_text_field/app_text_form_field.dart';
import '../../core/ui/info_icon_with_tooltip.dart';
import '../view_models/create_goal_screen_viewmodel.dart';

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
  String? _selectedAssigneeWorkspaceId;

  void _onAssigneeSelected(List<AppSelectFieldOption> selectedOptions) {
    setState(() {
      _selectedAssigneeWorkspaceId = selectedOptions[0].value as String;
    });
  }

  void _onAssigneeCleared() {
    setState(() {
      _selectedAssigneeWorkspaceId = null;
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
          ListenableBuilder(
            listenable: widget.viewModel,
            builder: (builderContext, _) {
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

              return AppSelectFormField(
                options: options,
                onSelected: _onAssigneeSelected,
                onCleared: _onAssigneeCleared,
                label: builderContext.localization.objectiveAssigneeLabel,
                validator: (assignee) =>
                    _validateAssignee(builderContext, assignee),
              );
            },
          ),
          const SizedBox(height: 10),
          AppTextFormField(
            controller: _requiredPointsController,
            label: context.localization.goalRequiredPointsLabel,
            validator: _validateRequiredPoints,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            suffixIcon: InfoIconWithTooltip(
              message: context.localization.goalRequiredPointsNote,
              tooltipShowDuration: 8,
            ),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          const SizedBox(height: 30),
          ListenableBuilder(
            listenable: widget.viewModel.createGoal,
            builder: (builderContext, _) => AppFilledButton(
              onPress: _onSubmit,
              label: builderContext.localization.goalCreateNew,
              isLoading: widget.viewModel.createGoal.running,
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
      final requiredPoints = int.tryParse(
        _requiredPointsController.text.trim(),
      );

      if (requiredPoints == null) {
        // should be non-triggerable case, do something
        return;
      }

      widget.viewModel.createGoal.execute((
        title,
        description,
        _selectedAssigneeWorkspaceId!,
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
    switch (trimmedValue) {
      case final String trimmedValue when trimmedValue.isEmpty:
        return context.localization.misc_requiredField;
      case final String trimmedValue when int.tryParse(trimmedValue) == null:
        return context.localization.createNewGoalRequiredPointsNaN;
      case final String trimmedValue
          when int.tryParse(trimmedValue)! % ObjectiveRules.rewardPointsStep !=
              0:
        return context.localization.createNewGoalRequiredPointsNotMultipleOf10;
      default:
        return null;
    }
  }
}
