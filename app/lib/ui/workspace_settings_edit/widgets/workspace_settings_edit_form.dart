import 'package:flutter/material.dart';

import '../../../domain/constants/validation_rules.dart';
import '../../core/l10n/l10n_extensions.dart';
import '../../core/ui/app_filled_button.dart';
import '../../core/ui/app_text_field/app_text_form_field.dart';
import '../view_models/workspace_settings_edit_screen_view_model.dart';

class WorkspaceSettingsEditForm extends StatefulWidget {
  const WorkspaceSettingsEditForm({super.key, required this.viewModel});

  final WorkspaceSettingsEditScreenViewModel viewModel;

  @override
  State<WorkspaceSettingsEditForm> createState() =>
      _WorkspaceSettingsEditFormState();
}

class _WorkspaceSettingsEditFormState extends State<WorkspaceSettingsEditForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.viewModel.details!.name;
    _descriptionController.text = widget.viewModel.details!.description ?? '';
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
            label: context.localization.workspaceNameLabel,
            validator: _validateName,
            textInputAction: TextInputAction.next,
            maxCharacterCount: ValidationRules.workspaceNameMaxLength,
          ),
          const SizedBox(height: 10),
          AppTextFormField(
            controller: _descriptionController,
            label: context.localization.workspaceDescriptionLabel,
            validator: _validateDescription,
            minLines: 3,
            maxLines: null,
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.done,
            required: false,
            maxCharacterCount: ValidationRules.workspaceDescriptionMaxLength,
          ),
          const SizedBox(height: 30),
          ListenableBuilder(
            listenable: widget.viewModel.editWorkspaceDetails,
            builder: (builderContext, _) => AppFilledButton(
              onPress: _onSubmit,
              label: builderContext.localization.editDetailsSubmit,
              loading: widget.viewModel.editWorkspaceDetails.running,
            ),
          ),
        ],
      ),
    );
  }

  void _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      final trimmedName = _nameController.text.trim();
      final name = trimmedName.isNotEmpty ? trimmedName : null;
      final trimmedDescription = _descriptionController.text.trim();
      final description = trimmedDescription.isNotEmpty
          ? trimmedDescription
          : null;

      widget.viewModel.editWorkspaceDetails.execute((name, description));
    }
  }

  String? _validateName(String? value) {
    final trimmedValue = value?.trim();
    switch (trimmedValue) {
      case final String trimmedValue when trimmedValue.isEmpty:
        return context.localization.misc_requiredField;
      case final String trimmedValue
          when trimmedValue.length < ValidationRules.workspaceNameMinLength:
        return context.localization.workspaceCreateNameMinLength;
      case final String trimmedValue
          when trimmedValue.length > ValidationRules.workspaceNameMaxLength:
        return context.localization.workspaceCreateNameMaxLength;
      default:
        return null;
    }
  }

  String? _validateDescription(String? value) {
    final trimmedValue = value?.trim();
    switch (trimmedValue) {
      case final String trimmedValue
          when trimmedValue.length >
              ValidationRules.workspaceDescriptionMaxLength:
        return context.localization.workspaceCreateDescriptionMaxLength;
      default:
        return null;
    }
  }
}
