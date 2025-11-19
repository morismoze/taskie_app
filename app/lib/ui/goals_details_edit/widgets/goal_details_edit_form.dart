import 'package:flutter/material.dart';

import '../../../domain/constants/objective_rules.dart';
import '../../../domain/constants/validation_rules.dart';
import '../../core/l10n/l10n_extensions.dart';
import '../../core/ui/app_filled_button.dart';
import '../../core/ui/app_slider_field/app_slider_form_field.dart';
import '../../core/ui/app_text_field/app_text_form_field.dart';
import '../../core/utils/extensions.dart';
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
  late ValueNotifier<int> _requiredPointsNotifier;

  @override
  void initState() {
    _titleController.text = widget.viewModel.details!.title;
    _descriptionController.text = widget.viewModel.details!.description ?? '';
    _requiredPointsNotifier = ValueNotifier(
      widget.viewModel.details!.requiredPoints,
    );
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _onRequiredPointsChanged(double points) {
    setState(() {
      _requiredPointsNotifier.value = points.toInt();
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
          // Assignee
          const SizedBox(height: 30),
          const SizedBox(height: 20),
          ValueListenableBuilder(
            valueListenable: _requiredPointsNotifier,
            builder: (builderContext, requiredPointsValue, _) =>
                AppSliderFormField(
                  label: builderContext.localization.goalRequiredPointsLabel,
                  value: requiredPointsValue.toDouble(),
                  onChanged: _onRequiredPointsChanged,
                  step: ObjectiveRules.rewardPointsStep,
                  min: ObjectiveRules.rewardPointsMin.toDouble(),
                  max: ObjectiveRules.rewardPointsMax.toDouble(),
                ),
          ),
          const SizedBox(height: 30),
          ListenableBuilder(
            listenable: Listenable.merge([
              widget.viewModel.editGoalDetails,
              _titleController,
              _descriptionController,
              _requiredPointsNotifier,
            ]),
            builder: (builderContext, _) {
              final dirty =
                  _titleController.text != widget.viewModel.details!.title ||
                  _descriptionController.text.nullIfEmpty !=
                      widget.viewModel.details!.description ||
                  _requiredPointsNotifier.value !=
                      widget.viewModel.details!.requiredPoints;

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
      final description = trimmedDescription.nullIfEmpty;

      widget.viewModel.editGoalDetails.execute((
        title,
        description,
        _requiredPointsNotifier.value,
        '',
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
