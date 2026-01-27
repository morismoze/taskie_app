import 'package:flutter/material.dart';

import '../../../domain/constants/validation_rules.dart';
import '../../core/l10n/l10n_extensions.dart';
import '../../core/theme/dimens.dart';
import '../../core/ui/app_filled_button.dart';
import '../../core/ui/app_text_field/app_text_form_field.dart';
import '../view_models/create_workspace_user_screen_view_model.dart';

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
  void initState() {
    super.initState();
    widget.viewModel.createVirtualUser.addListener(_onVirtualUserCreateResult);
  }

  @override
  void didUpdateWidget(covariant CreateVirtualUserForm oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.viewModel.createVirtualUser !=
        oldWidget.viewModel.createVirtualUser) {
      oldWidget.viewModel.createVirtualUser.removeListener(
        _onVirtualUserCreateResult,
      );
      widget.viewModel.createVirtualUser.addListener(
        _onVirtualUserCreateResult,
      );
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    widget.viewModel.createVirtualUser.removeListener(
      _onVirtualUserCreateResult,
    );
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
                validator: _validateFirstName,
                textInputAction: TextInputAction.next,
                maxCharacterCount: ValidationRules.workspaceUserNameMaxLength,
              ),
              const SizedBox(height: Dimens.paddingVertical / 2.25),
              AppTextFormField(
                controller: _lastNameController,
                label: context.localization.workspaceUserLastNameLabel,
                validator: _validateLastName,
                textInputAction: TextInputAction.done,
                maxCharacterCount: ValidationRules.workspaceUserNameMaxLength,
              ),
              const SizedBox(height: Dimens.paddingVertical / 1.2),
              ListenableBuilder(
                listenable: Listenable.merge([
                  widget.viewModel.createVirtualUser,
                  _firstNameController,
                  _lastNameController,
                ]),
                builder: (builderContext, _) {
                  final enabledSubmit =
                      _firstNameController.text.isNotEmpty &&
                      _lastNameController.text.isNotEmpty;

                  return AppFilledButton(
                    onPress: _onSubmit,
                    label: builderContext
                        .localization
                        .workspaceUsersManagementCreateVirtualUserSubmit,
                    loading: widget.viewModel.createVirtualUser.running,
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
    // Unfocus the last field
    FocusScope.of(context).unfocus();

    if (_formKey.currentState!.validate()) {
      final firstName = _firstNameController.text.trim();
      final lastName = _lastNameController.text.trim();
      widget.viewModel.createVirtualUser.execute((firstName, lastName));
    }
  }

  String? _validateFirstName(String? value) {
    final trimmedValue = value?.trim();
    switch (trimmedValue) {
      case final String trimmedValue when trimmedValue.isEmpty:
        return context.localization.misc_requiredField;
      case final String trimmedValue
          when trimmedValue.length < ValidationRules.workspaceUserNameMinLength:
        return context.localization.workspaceUserFirstNameMinLength;
      case final String trimmedValue
          when trimmedValue.length > ValidationRules.workspaceUserNameMaxLength:
        return context.localization.workspaceUserFirstNameMaxLength;
      default:
        return null;
    }
  }

  String? _validateLastName(String? value) {
    final trimmedValue = value?.trim();
    switch (trimmedValue) {
      case final String trimmedValue when trimmedValue.isEmpty:
        return context.localization.misc_requiredField;
      case final String trimmedValue
          when trimmedValue.length < ValidationRules.workspaceUserNameMinLength:
        return context.localization.workspaceUserLastNameMinLength;
      case final String trimmedValue
          when trimmedValue.length > ValidationRules.workspaceUserNameMaxLength:
        return context.localization.workspaceUserLastNameMaxLength;
      default:
        return null;
    }
  }

  void _onVirtualUserCreateResult() {
    if (widget.viewModel.createVirtualUser.completed) {
      widget.viewModel.createVirtualUser.clearResult();
      // Clear form
      _firstNameController.clear();
      _lastNameController.clear();
    }
  }
}
