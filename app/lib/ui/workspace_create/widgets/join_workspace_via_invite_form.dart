import 'package:flutter/material.dart';

import '../../../config/environment/env.dart';
import '../../../domain/constants/validation_rules.dart';
import '../../../routing/routes.dart';
import '../../core/l10n/l10n_extensions.dart';
import '../../core/ui/app_filled_button.dart';
import '../../core/ui/app_text_field/app_text_form_field.dart';
import '../view_models/create_workspace_screen_viewmodel.dart';

class JoinWorkspaceViaInviteForm extends StatefulWidget {
  const JoinWorkspaceViaInviteForm({super.key, required this.viewModel});

  final CreateWorkspaceScreenViewModel viewModel;

  @override
  State<JoinWorkspaceViaInviteForm> createState() =>
      _JoinWorkspaceViaInviteFormState();
}

class _JoinWorkspaceViaInviteFormState
    extends State<JoinWorkspaceViaInviteForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _inviteLinkController = TextEditingController();

  @override
  void dispose() {
    _inviteLinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final workspaceJoinDeepLinkRoute = Routes.workspaceJoin('example');
    final serverBaseUrl = Env.deepLinkBaseUrl;
    final inviteLinkExample = '$serverBaseUrl$workspaceJoinDeepLinkRoute';

    return Column(
      spacing: 30,
      children: [
        Text(
          context.localization.workspaceCreateJoinViaInviteLinkDescription,
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
        ),
        Text.rich(
          TextSpan(
            text: '${context.localization.misc_note}: ',
            style: Theme.of(context).textTheme.labelMedium!.copyWith(
              fontSize: 13,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
            ),
            children: [
              TextSpan(
                text: context.localization.workspaceCreateJoinViaInviteLinkNote(
                  inviteLinkExample,
                ),
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
        Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUnfocus,
          child: Column(
            children: [
              AppTextFormField(
                controller: _inviteLinkController,
                label: context.localization.workspaceInviteLabel,
                validator: _validateInviteLink,
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: 20),
              ListenableBuilder(
                listenable: Listenable.merge([
                  widget.viewModel.joinWorkspaceViaInviteLink,
                  _inviteLinkController,
                ]),
                builder: (builderContext, _) {
                  final enabledSubmit = _inviteLinkController.text.isNotEmpty;

                  return AppFilledButton(
                    onPress: _onSubmit,
                    label: builderContext
                        .localization
                        .workspaceCreateJoinViaInviteLinkSubmit,
                    loading:
                        widget.viewModel.joinWorkspaceViaInviteLink.running,
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
      final inviteLink = _inviteLinkController.text.trim();
      widget.viewModel.joinWorkspaceViaInviteLink.execute(inviteLink);
    }
  }

  String? _validateInviteLink(String? value) {
    final trimmedValue = value?.trim();
    switch (trimmedValue) {
      case final String trimmedValue when trimmedValue.isEmpty:
        return context.localization.misc_requiredField;
      case final String trimmedValue
          when !RegExp(
            ValidationRules.workspaceInviteLinkRegex,
          ).hasMatch(trimmedValue):
        return context.localization.workspaceCreateJoinViaInviteLinkInvalid;
      default:
        return null;
    }
  }
}
