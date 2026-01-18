import 'package:flutter/material.dart';

import '../../../utils/command.dart';
import '../l10n/l10n_extensions.dart';
import '../theme/dimens.dart';
import 'app_filled_button.dart';
import 'app_outlined_button.dart';

/// This represents two basic action buttons: Cancel and Submit,
/// listening on the [command] if it is provided.
/// It is used in number of places, so it's good to have it as
/// a reusable widget.
class ActionButtonBar extends StatelessWidget {
  const ActionButtonBar._({
    super.key,
    required this.onSubmit,
    this.onCancel,
    this.command,
    this.submitButtonText,
    this.cancelButtonText,
    this.submitButtonColor,
  });

  final VoidCallback onSubmit;
  final VoidCallback? onCancel;
  final Command? command;
  // These three below are functions because we need the builder's context
  // for text (localisation) and for the color (Theme style)
  final String? submitButtonText;
  final String? cancelButtonText;
  final Color? submitButtonColor;

  /// Simple non-Command buttons
  factory ActionButtonBar({
    Key? key,
    required VoidCallback onSubmit,
    VoidCallback? onCancel,
    String? submitButtonText,
    String? cancelButtonText,
    Color? submitButtonColor,
  }) {
    return ActionButtonBar._(
      key: key,
      onSubmit: onSubmit,
      onCancel: onCancel,
      submitButtonText: submitButtonText,
      cancelButtonText: cancelButtonText,
      submitButtonColor: submitButtonColor,
    );
  }

  /// Creates action buttons which listen to a Command
  factory ActionButtonBar.withCommand({
    Key? key,
    required Command command,
    required VoidCallback onSubmit,
    VoidCallback? onCancel,
    String? submitButtonText,
    String? cancelButtonText,
    Color? submitButtonColor,
  }) {
    return ActionButtonBar._(
      key: key,
      onSubmit: onSubmit,
      onCancel: onCancel,
      command: command,
      submitButtonText: submitButtonText,
      cancelButtonText: cancelButtonText,
      submitButtonColor: submitButtonColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (command != null) {
      return ListenableBuilder(
        listenable: command!,
        builder: (context, _) {
          return _buildButtons(
            context: context,
            isLoading: command!.running,
            submitButtonText: submitButtonText,
            cancelButtonText: cancelButtonText,
          );
        },
      );
    }

    return _buildButtons(
      context: context,
      submitButtonText: submitButtonText,
      cancelButtonText: cancelButtonText,
    );
  }

  Widget _buildButtons({
    required BuildContext context,
    bool isLoading = false,
    String? submitButtonText,
    String? cancelButtonText,
  }) {
    return Row(
      spacing: Dimens.paddingHorizontal,
      children: [
        if (onCancel != null)
          Expanded(
            flex: 2,
            child: AppOutlinedButton(
              onPress: onCancel!,
              label: cancelButtonText ?? context.localization.misc_cancel,
              color: Theme.of(context).colorScheme.secondary,
              disabled: isLoading,
            ),
          ),
        Expanded(
          flex: 4,
          child: AppFilledButton(
            onPress: onSubmit,
            loading: isLoading,
            label: submitButtonText ?? context.localization.misc_submit,
            backgroundColor: submitButtonColor,
          ),
        ),
      ],
    );
  }
}
