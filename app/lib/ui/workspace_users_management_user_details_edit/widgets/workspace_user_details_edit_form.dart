import 'package:flutter/material.dart';

import '../../../data/services/api/user/models/response/user_response.dart';
import '../../../domain/constants/validation_rules.dart';
import '../../core/l10n/l10n_extensions.dart';
import '../../core/ui/app_filled_button.dart';
import '../../core/ui/app_select_field/app_select_field.dart';
import '../../core/ui/app_select_field/app_select_form_field.dart';
import '../../core/ui/app_text_field/app_text_form_field.dart';
import '../../core/ui/info_icon_with_tooltip.dart';
import '../../core/utils/extensions.dart';
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
  late WorkspaceRole? _selectedRole;

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

  void _onRoleCleared() {
    setState(() {
      _selectedRole = null;
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
      label: widget.viewModel.details!.role.l10n(context),
      value: widget.viewModel.details!.role,
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
            maxCharacterCount: isVirtualUser
                ? ValidationRules.workspaceUserNameMaxLength
                : null,
            // First name is not editable for real users which signed up via a auth provider
            readOnly: !isVirtualUser,
            suffixIcon: !isVirtualUser
                ? InfoIconWithTooltip(
                    message: context
                        .localization
                        .workspaceUsersManagementUserDetailsEditFirstNameBlocked,
                    tooltipShowDuration: 6,
                  )
                : null,
          ),
          const SizedBox(height: 10),
          AppTextFormField(
            controller: _lastNameController,
            label: context.localization.workspaceUserLastNameLabel,
            validator: _validateLastName,
            textInputAction: TextInputAction.done,
            maxCharacterCount: isVirtualUser
                ? ValidationRules.workspaceUserNameMaxLength
                : null,
            // Last name is not editable for real users which signed up via a auth provider
            readOnly: !isVirtualUser,
            suffixIcon: !isVirtualUser
                ? InfoIconWithTooltip(
                    message: context
                        .localization
                        .workspaceUsersManagementUserDetailsEditLastNameBlocked,
                    tooltipShowDuration: 6,
                  )
                : null,
          ),
          const SizedBox(height: 10),
          AppSelectFormField(
            options: roles,
            validator: (selected) => _validateRole(context, selected),
            initialValue: [initialRole],
            onSelected: _onRoleSelected,
            onCleared: _onRoleCleared,
            label: context.localization.roleLabel,
            // Role is not editable for virtual users
            enabled: !isVirtualUser,
            trailing: isVirtualUser
                ? InfoIconWithTooltip(
                    message: context
                        .localization
                        .workspaceUsersManagementUserDetailsEditRoleBlocked,
                  )
                : null,
          ),
          const SizedBox(height: 30),
          ListenableBuilder(
            listenable: widget.viewModel.editWorkspaceUserDetails,
            builder: (builderContext, _) => AppFilledButton(
              onPress: _onSubmit,
              label: builderContext.localization.editDetailsSubmit,
              loading: widget.viewModel.editWorkspaceUserDetails.running,
            ),
          ),
        ],
      ),
    );
  }

  void _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      final firstName = _firstNameController.text.trim();
      final lastName = _lastNameController.text.trim();

      widget.viewModel.editWorkspaceUserDetails.execute((
        firstName,
        lastName,
        _selectedRole,
      ));
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

  String? _validateRole(
    BuildContext context,
    List<AppSelectFieldOption>? role,
  ) {
    switch (role) {
      case final List<AppSelectFieldOption>? value when value == null:
      case final List<AppSelectFieldOption> value when value.isEmpty:
        return context.localization.misc_requiredField;
      default:
        return null;
    }
  }
}
