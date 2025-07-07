import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/constants/validation_rules.dart';
import '../../../routing/routes.dart';
import '../../core/l10n/l10n_extensions.dart';
import '../../core/ui/app_filled_button.dart';
import '../../core/ui/app_snackbar.dart';
import '../../core/ui/app_text_form_field.dart';
import '../../workspace_create/view_models/create_workspace_viewmodel.dart';

class CreateForm extends StatefulWidget {
  const CreateForm({super.key, required this.viewModel});

  final CreateWorkspaceScreenViewModel viewModel;

  @override
  State<CreateForm> createState() => _CreateFormState();
}

class _CreateFormState extends State<CreateForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.viewModel.createWorkspace.addListener(_onResult);
  }

  @override
  void didUpdateWidget(covariant CreateForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.viewModel.createWorkspace.removeListener(_onResult);
    widget.viewModel.createWorkspace.addListener(_onResult);
  }

  @override
  void dispose() {
    widget.viewModel.createWorkspace.removeListener(_onResult);
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
            builder: (context, _) => AppFilledButton(
              onPress: _onSubmit,
              label: context.localization.workspaceCreateLabel,
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

  void _onResult() {
    if (widget.viewModel.createWorkspace.completed) {
      widget.viewModel.createWorkspace.clearResult();
      context.go(Routes.tasks);
    }

    if (widget.viewModel.createWorkspace.error) {
      widget.viewModel.createWorkspace.clearResult();
      AppSnackbar.showError(
        context: context,
        message: context.localization.errorWhileCreatingWorkspace,
      );
    }
  }
}
