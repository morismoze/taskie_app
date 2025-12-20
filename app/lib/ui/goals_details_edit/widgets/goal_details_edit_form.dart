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
import '../view_models/goal_details_edit_screen_view_model.dart';

class GoalDetailsEditForm extends StatefulWidget {
  const GoalDetailsEditForm({super.key, required this.viewModel});

  final GoalDetailsEditScreenViewModel viewModel;

  @override
  State<GoalDetailsEditForm> createState() => _GoalDetailsEditFormState();
}

class _GoalDetailsEditFormState extends State<GoalDetailsEditForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _requiredPointsController =
      TextEditingController();
  final ValueNotifier<AppSelectFieldOption<WorkspaceUser>?>
  _selectedAssigneeNotifier = ValueNotifier(null);

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.viewModel.details!.title;
    _descriptionController.text = widget.viewModel.details!.description ?? '';
    _requiredPointsController.text = widget.viewModel.details!.requiredPoints
        .toString();
    _selectedAssigneeNotifier.value = AppSelectFieldOption(
      label: UserUtils.constructFullName(
        firstName: widget.viewModel.details!.assignee.firstName,
        lastName: widget.viewModel.details!.assignee.lastName,
      ),
      value: widget.viewModel.workspaceMembers.firstWhere(
        (member) => member.id == widget.viewModel.details!.assignee.id,
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _requiredPointsController.dispose();
    _selectedAssigneeNotifier.dispose();
    super.dispose();
  }

  void _onAssigneeSelected(AppSelectFieldOption<WorkspaceUser> selectedOption) {
    setState(() {
      _selectedAssigneeNotifier.value = selectedOption;
    });
  }

  void _onAssigneeCleared() {
    setState(() {
      _selectedAssigneeNotifier.value = null;
    });
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
          const SizedBox(height: 20),
          AppTextFormField(
            controller: _requiredPointsController,
            label: context.localization.goalRequiredPointsLabel,
            validator: _validateRequiredPoints,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          const SizedBox(height: 30),
          ListenableBuilder(
            listenable: Listenable.merge([
              widget.viewModel.editGoalDetails,
              _titleController,
              _descriptionController,
              _requiredPointsController,
              _selectedAssigneeNotifier,
            ]),
            builder: (builderContext, _) {
              final dirty =
                  _titleController.text != widget.viewModel.details!.title ||
                  _descriptionController.text.nullIfEmpty !=
                      widget.viewModel.details!.description ||
                  _requiredPointsController.text !=
                      widget.viewModel.details!.requiredPoints.toString() ||
                  _selectedAssigneeNotifier.value?.value.id !=
                      widget.viewModel.details!.assignee.id;

              return AppFilledButton(
                onPress: _onSubmit,
                label: builderContext.localization.editDetailsSubmit,
                loading: widget.viewModel.editGoalDetails.running,
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
      final requiredPoints = int.parse(_requiredPointsController.text.trim());
      final description = trimmedDescription.nullIfEmpty;
      final assigneeId = _selectedAssigneeNotifier.value!.value.id;

      widget.viewModel.editGoalDetails.execute((
        title,
        description,
        requiredPoints,
        assigneeId,
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
