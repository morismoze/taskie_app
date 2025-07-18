import 'package:flutter/material.dart';

import '../../../domain/constants/validation_rules.dart';
import '../../core/l10n/l10n_extensions.dart';
import '../../core/ui/app_filled_button.dart';
import '../../core/ui/app_text_field/app_text_form_field.dart';
import '../view_models/create_workspace_user_screen_viewmodel.dart';

class CreateVirtualUserForm extends StatefulWidget {
  const CreateVirtualUserForm({super.key, required this.viewModel});

  final CreateWorkspaceUserScreenViewModel viewModel;

  @override
  State<CreateVirtualUserForm> createState() => _CreateVirtualUserFormState();
}

class _CreateVirtualUserFormState extends State<CreateVirtualUserForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 30,
      children: [
        Text(
          context
              .localization
              .workspaceUsersManagementCreateVirtualUserDescription,
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
                controller: _firstNameController,
                label: context.localization.workspaceUserFirstNameLabel,
                validator: _validateName,
                textInputAction: TextInputAction.next,
                maxCharacterCount: ValidationRules.workspaceUserNameMaxLength,
              ),
              const SizedBox(height: 10),
              AppTextFormField(
                controller: _lastNameController,
                label: context.localization.workspaceUserLastNameLabel,
                validator: _validateName,
                textInputAction: TextInputAction.go,
                maxCharacterCount: ValidationRules.workspaceUserNameMaxLength,
              ),
              const SizedBox(height: 30),
              ListenableBuilder(
                listenable: widget.viewModel.createVirtualUser,
                builder: (builderContext, _) => AppFilledButton(
                  onPress: _onSubmit,
                  label: builderContext
                      .localization
                      .workspaceUsersManagementCreateVirtualUserSubmit,
                  isLoading: widget.viewModel.createVirtualUser.running,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      final firstName = _firstNameController.text;
      final lastName = _lastNameController.text;
      widget.viewModel.createVirtualUser.execute((firstName, lastName));
    }
  }

  String? _validateName(String? value) {
    switch (value) {
      case final String? value when value == null:
        return context.localization.requiredField;
      case final String value
          when value.length < ValidationRules.workspaceUserNameMinLength:
        return context.localization.workspaceCreateNameMinLength;
      case final String value
          when value.length > ValidationRules.workspaceUserNameMaxLength:
        return context.localization.workspaceCreateNameMaxLength;
      default:
        return null;
    }
  }
}
