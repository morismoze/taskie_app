import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/l10n/l10n_extensions.dart';
import '../../../core/utils/app_urls.dart';

class LegalAgreementDisclaimer extends StatelessWidget {
  const LegalAgreementDisclaimer({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: Theme.of(context).textTheme.bodySmall,
        children: [
          TextSpan(text: '${context.localization.signInLegislation1} '),
          TextSpan(
            text: context.localization.signInLegislation2,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () => launchUrl(
                AppUrls.termsAndConditions,
              ).catchError((_) => false),
          ),
          TextSpan(text: ' ${context.localization.signInLegislation3} '),
          TextSpan(
            text: context.localization.signInLegislation4,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () =>
                  launchUrl(AppUrls.privacyPolicy).catchError((_) => false),
          ),
          const TextSpan(text: '.'),
        ],
      ),
    );
  }
}
