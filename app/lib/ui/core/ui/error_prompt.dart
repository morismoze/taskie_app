import 'package:flutter/material.dart';

import '../../../config/assets.dart';
import '../l10n/l10n_extensions.dart';
import '../theme/dimens.dart';
import 'app_outlined_button.dart';

/// This is used as a generic error prompt being
/// showed in case there was an error while fetching
/// from the server.
class ErrorPrompt extends StatelessWidget {
  const ErrorPrompt({super.key, required this.onRetry, this.text});

  final VoidCallback onRetry;
  final String? text;

  @override
  Widget build(BuildContext context) {
    final finalText = text ?? context.localization.misc_errorPrompt;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Dimens.of(context).paddingScreenHorizontal,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const FractionallySizedBox(
            widthFactor: 0.85,
            child: Image(image: AssetImage(Assets.errorPromptIllustration)),
          ),
          const SizedBox(height: 20),
          FractionallySizedBox(
            widthFactor: 0.9,
            child: Text(
              finalText,
              style: Theme.of(context).textTheme.bodyMedium!,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),
          AppOutlinedButton(
            onPress: onRetry,
            label: context.localization.misc_retry,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ],
      ),
    );
  }
}
