import 'package:flutter/material.dart';

import '../../../data/services/api/user/models/response/user_response.dart';
import '../../../domain/constants/validation_rules.dart';
import '../../core/l10n/l10n_extensions.dart';
import '../../core/ui/app_filled_button.dart';
import '../../core/ui/app_select_field/app_select_field.dart';
import '../../core/ui/app_select_field/app_select_form_field.dart';
import '../../core/ui/app_text_field/app_text_form_field.dart';
import '../../core/ui/blocked_info_icon.dart';
import '../../core/utils/role_extension.dart';
import '../view_models/workspace_user_details_edit_screen_view_model.dart';

class WorkspaceUserDetailsEditForm extends StatefulWidget {
  const WorkspaceUserDetailsEditForm({super.key, required this.viewModel});

  final WorkspaceUserDetailsEditScreenViewModel viewModel;

  @override
  State<WorkspaceUserDetailsEditForm> createState() =>
      _WorkspaceUserDetailsEditFormState();
}

class _WorkspaceUserDetailsEditFormState
    extends State<WorkspaceUserDetailsEditForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  late WorkspaceRole _selectedRole;

  @override
  void initState() {
    super.initState();
    _selectedRole = widget.viewModel.details!.role;
    _firstNameController.text = widget.viewModel.details!.firstName;
    _lastNameController.text = widget.viewModel.details!.lastName;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  void _onRoleSelected(List<AppSelectFieldOption> selectedOptions) {
    setState(() {
      _selectedRole = selectedOptions[0].value as WorkspaceRole;
    });
  }

  @override
  Widget build(BuildContext context) {
    final roles = List<AppSelectFieldOption>.from([
      AppSelectFieldOption(
        label: WorkspaceRole.manager.l10n(context),
        value: WorkspaceRole.manager,
      ),
      AppSelectFieldOption(
        label: WorkspaceRole.member.l10n(context),
        value: WorkspaceRole.member,
      ),
    ]).toList();
    final initialRole = AppSelectFieldOption(
      label: _selectedRole.l10n(context),
      value: _selectedRole,
    );
    // Virtual users don't have emails, and real users must have emails.
    final isVirtualUser = widget.viewModel.details!.email == null;

    return Form(
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
            // First name is not editable for real users which signed up via a auth provider
            readOnly: !isVirtualUser,
            suffix: !isVirtualUser
                ? BlockedInfoIcon(
                    message: context
                        .localization
                        .workspaceUsersManagementUserDetailsEditFirstNameBlocked,
                  )
                : null,
          ),
          const SizedBox(height: 10),
          AppTextFormField(
            controller: _lastNameController,
            label: context.localization.workspaceUserLastNameLabel,
            validator: _validateLastName,
            textInputAction: TextInputAction.go,
            maxCharacterCount: ValidationRules.workspaceUserNameMaxLength,
            // Last name is not editable for real users which signed up via a auth provider
            readOnly: !isVirtualUser,
            suffix: !isVirtualUser
                ? BlockedInfoIcon(
                    message: context
                        .localization
                        .workspaceUsersManagementUserDetailsEditLastNameBlocked,
                  )
                : null,
          ),
          const SizedBox(height: 10),
          AppSelectFormField(
            options: roles,
            initialValue: [initialRole],
            onSelected: _onRoleSelected,
            label: context.localization.roleLabel,
            // Role is not editable for virtual users
            enabled: !isVirtualUser,
            disabledWidgetTrailingTooltipMessage: context
                .localization
                .workspaceUsersManagementUserDetailsEditRoleBlocked,
          ),
          const SizedBox(height: 30),
          ListenableBuilder(
            listenable: widget.viewModel.editWorkspaceUserDetails,
            builder: (builderContext, _) => AppFilledButton(
              onPress: _onSubmit,
              label: builderContext
                  .localization
                  .workspaceUsersManagementUserDetailsEditSubmit,
              isLoading: widget.viewModel.editWorkspaceUserDetails.running,
            ),
          ),
        ],
      ),
    );
  }

  void _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      final firstName = _firstNameController.text;
      final lastName = _lastNameController.text;
      final role = _selectedRole;
      widget.viewModel.editWorkspaceUserDetails.execute((
        firstName,
        lastName,
        role,
      ));
    }
  }

  String? _validateFirstName(String? value) {
    switch (value) {
      case final String? value when value == null:
        return context.localization.misc_requiredField;
      case final String value
          when value.length < ValidationRules.workspaceUserNameMinLength:
        return context.localization.workspaceUserFirstNameMinLength;
      case final String value
          when value.length > ValidationRules.workspaceUserNameMaxLength:
        return context.localization.workspaceUserFirstNameMaxLength;
      default:
        return null;
    }
  }

  String? _validateLastName(String? value) {
    switch (value) {
      case final String? value when value == null:
        return context.localization.misc_requiredField;
      case final String value
          when value.length < ValidationRules.workspaceUserNameMinLength:
        return context.localization.workspaceUserLastNameMinLength;
      case final String value
          when value.length > ValidationRules.workspaceUserNameMaxLength:
        return context.localization.workspaceUserLastNameMaxLength;
      default:
        return null;
    }
  }
}
