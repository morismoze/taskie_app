import 'package:flutter/material.dart';

import '../../../domain/constants/validation_rules.dart';
import '../../core/l10n/l10n_extensions.dart';
import '../../core/theme/dimens.dart';
import '../../core/ui/app_filled_button.dart';
import '../../core/ui/app_text_field/app_text_form_field.dart';
import '../../core/utils/extensions.dart';
import '../view_models/create_workspace_screen_view_model.dart';

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
    return Column(
      spacing: 30,
      children: [
        Text(
          context.localization.workspaceCreateNewDescription,
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
        ),
        Form(
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
              const SizedBox(height: Dimens.paddingVertical / 2.25),
              AppTextFormField(
                controller: _descriptionController,
                label: context.localization.workspaceDescriptionLabel,
                validator: _validateDescription,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.done,
                required: false,
                maxCharacterCount:
                    ValidationRules.workspaceDescriptionMaxLength,
              ),
              const SizedBox(height: Dimens.paddingVertical / 1.2),
              ListenableBuilder(
                listenable: Listenable.merge([
                  widget.viewModel.createWorkspace,
                  _nameController,
                  _descriptionController,
                ]),
                builder: (builderContext, _) {
                  // Description is optional
                  final enabledSubmit = _nameController.text.isNotEmpty;

                  return AppFilledButton(
                    onPress: _onSubmit,
                    label: builderContext.localization.workspaceCreateLabel,
                    loading: widget.viewModel.createWorkspace.running,
                    disabled: !enabledSubmit,
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text.trim();
      final trimmedDescription = _descriptionController.text.trim();
      final description = trimmedDescription.nullIfEmpty;
      widget.viewModel.createWorkspace.execute((name, description));
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
