import 'package:flutter/material.dart';

import '../../../domain/constants/validation_rules.dart';
import '../../core/l10n/l10n_extensions.dart';
import '../../core/theme/dimens.dart';
import '../../core/ui/app_filled_button.dart';
import '../../core/ui/app_text_field/app_text_form_field.dart';
import '../../core/utils/extensions.dart';
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
          const SizedBox(height: Dimens.paddingVertical / 2.25),
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
          const SizedBox(height: Dimens.paddingVertical / 1.2),
          ListenableBuilder(
            listenable: Listenable.merge([
              widget.viewModel,
              widget.viewModel.editWorkspaceDetails,
              _nameController,
              _descriptionController,
            ]),
            builder: (builderContext, _) {
              final isDirty =
                  _nameController.text != widget.viewModel.details!.name ||
                  _descriptionController.text.nullIfEmpty !=
                      widget.viewModel.details!.description;

              return AppFilledButton(
                onPress: _onSubmit,
                label: builderContext.localization.editDetailsSubmit,
                loading: widget.viewModel.editWorkspaceDetails.running,
                disabled: !isDirty,
              );
            },
          ),
        ],
      ),
    );
  }

  void _onSubmit() {
    // Unfocus the last field
    FocusScope.of(context).unfocus();

    if (_formKey.currentState!.validate()) {
      final name = _nameController.text.trim();
      final description = _descriptionController.text.trim().nullIfEmpty;

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
