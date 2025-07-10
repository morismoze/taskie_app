import 'package:flutter/material.dart';

import '../../../domain/constants/objective_rules.dart';
import '../../../domain/constants/validation_rules.dart';
import '../../core/l10n/l10n_extensions.dart';
import '../../core/ui/app_filled_button.dart';
import '../../core/ui/app_slider.dart';
import '../../core/ui/app_text_form_field.dart';
import '../view_models/create_task_viewmodel.dart';

class CreateForm extends StatefulWidget {
  const CreateForm({super.key, required this.viewModel});

  final CreateTaskViewmodel viewModel;

  @override
  State<CreateForm> createState() => _CreateFormState();
}

class _CreateFormState extends State<CreateForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _assigneeController = TextEditingController();
  int _rewardPoints = ObjectiveRules.rewardPointsMin;

  void _onRewardPointsChanged(double points) {
    setState(() {
      _rewardPoints = points.toInt();
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(covariant CreateForm oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUnfocus,
      child: Column(
        children: [
          AppTextFormField(
            controller: _nameController,
            label: context.localization.taskNameLabel,
            validator: _validateName,
            textInputAction: TextInputAction.next,
            maxCharacterCount: ValidationRules.taskNameMaxLength,
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
          AppTextFormField(
            controller: _descriptionController,
            label: context.localization.taskAssigneeLabel,
            validator: _validateDescription,
            maxLines: null,
            textInputAction: TextInputAction.next,
            required: false,
            maxCharacterCount: ValidationRules.workspaceDescriptionMaxLength,
          ),
          const SizedBox(height: 10),
          AppSlider(
            label: context.localization.taskRewardPointsLabel,
            value: _rewardPoints.toDouble(),
            onChanged: _onRewardPointsChanged,
            step: ObjectiveRules.rewardPointsStep,
            min: ObjectiveRules.rewardPointsMin.toDouble(),
            max: ObjectiveRules.rewardPointsMax.toDouble(),
          ),
          const SizedBox(height: 30),
          AppFilledButton(
            onPress: _onSubmit,
            label: context.localization.taskCreateNew,
          ),
        ],
      ),
    );
  }

  void _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text;
      final description = _descriptionController.text;
    }
  }

  String? _validateName(String? value) {
    switch (value) {
      case final String? value when value == null:
        return context.localization.requiredField;
      case final String value
          when value.length < ValidationRules.taskNameMinLength:
        return context.localization.taskNameMinLength;
      case final String value
          when value.length > ValidationRules.taskNameMaxLength:
        return context.localization.taskNameMaxLength;
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

  void _onResult() {}
}
