import 'package:flutter/material.dart';

import '../../../domain/constants/validation_rules.dart';
import '../../core/l10n/l10n_extensions.dart';
import '../../core/ui/app_filled_button.dart';
import '../../core/ui/app_text_form_field.dart';
import '../view_models/create_workspace_screen_viewmodel.dart';

class CreateWorkspaceForm extends StatefulWidget {
  const CreateWorkspaceForm({super.key, required this.viewModel});

  final CreateWorkspaceScreenViewModel viewModel;

  @override
  State<CreateWorkspaceForm> createState() => _CreateWorkspaceFormState();
}

class _CreateWorkspaceFormState extends State<CreateWorkspaceForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

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
            maxLines: null,
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.go,
            required: false,
            maxCharacterCount: ValidationRules.workspaceDescriptionMaxLength,
          ),
          const SizedBox(height: 30),
          ListenableBuilder(
            listenable: widget.viewModel.createWorkspace,
            builder: (builderContext, _) => AppFilledButton(
              onPress: _onSubmit,
              label: builderContext.localization.workspaceCreateLabel,
              isLoading: widget.viewModel.createWorkspace.running,
            ),
          ),
        ],
      ),
    );
  }

  void _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text;
      final description = _descriptionController.text;
      widget.viewModel.createWorkspace.execute((name, description));
    }
  }

  String? _validateName(String? value) {
    switch (value) {
      case final String? value when value == null:
        return context.localization.requiredField;
      case final String value
          when value.length < ValidationRules.workspaceNameMinLength:
        return context.localization.workspaceCreateNameMinLength;
      case final String value
          when value.length > ValidationRules.workspaceNameMaxLength:
        return context.localization.workspaceCreateNameMaxLength;
      default:
        return null;
    }
  }

  String? _validateDescription(String? value) {
    switch (value) {
      case final String value
          when value.length > ValidationRules.workspaceDescriptionMaxLength:
        return context.localization.workspaceCreateDescriptionMaxLength;
      default:
        return null;
    }
  }
}
