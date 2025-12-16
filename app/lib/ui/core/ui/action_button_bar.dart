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
    required this.onCancel,
    this.command,
    this.submitButtonText,
    this.cancelButtonText,
    this.submitButtonColor,
  });

  final void Function(BuildContext) onSubmit;
  final void Function(BuildContext) onCancel;
  final Command? command;
  // These three below are functions because we need the builder's context
  // for text (localisation) and for the color (Theme style)
  final String Function(BuildContext builderContext)? submitButtonText;
  final String Function(BuildContext builderContext)? cancelButtonText;
  final Color Function(BuildContext builderContext)? submitButtonColor;

  /// Simple non-Command buttons
  factory ActionButtonBar({
    Key? key,
    required VoidCallback onSubmit,
    required VoidCallback onCancel,
    String Function(BuildContext builderContext)? submitButtonText,
    String Function(BuildContext builderContext)? cancelButtonText,
    Color Function(BuildContext builderContext)? submitButtonColor,
  }) {
    return ActionButtonBar._(
      key: key,
      onSubmit: (_) => onSubmit(),
      onCancel: (_) => onCancel(),
      submitButtonText: submitButtonText,
      cancelButtonText: cancelButtonText,
      submitButtonColor: submitButtonColor,
    );
  }

  /// Creates action buttons which listen to a Command
  factory ActionButtonBar.withCommand({
    Key? key,
    required Command command,
    required void Function(BuildContext builderContext) onSubmit,
    required void Function(BuildContext builderContext) onCancel,
    String Function(BuildContext builderContext)? submitButtonText,
    String Function(BuildContext builderContext)? cancelButtonText,
    Color Function(BuildContext builderContext)? submitButtonColor,
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
    String Function(BuildContext builderContext)? submitButtonText,
    String Function(BuildContext builderContext)? cancelButtonText,
  }) {
    return Row(
      spacing: Dimens.paddingHorizontal,
      children: [
        Expanded(
          flex: 2,
          child: AppOutlinedButton(
            onPress: () => onCancel(context),
            label: cancelButtonText != null
                ? cancelButtonText(context)
                : context.localization.misc_cancel,
            color: Theme.of(context).colorScheme.secondary,
            disabled: isLoading,
          ),
        ),
        Expanded(
          flex: 4,
          child: AppFilledButton(
            onPress: () => onSubmit(context),
            loading: isLoading,
            label: submitButtonText != null
                ? submitButtonText(context)
                : context.localization.misc_submit,
            backgroundColor: submitButtonColor != null
                ? submitButtonColor!(context)
                : null,
          ),
        ),
      ],
    );
  }
}
