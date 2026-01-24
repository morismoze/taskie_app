import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/l10n/l10n_extensions.dart';
import '../../core/theme/dimens.dart';
import '../../core/ui/app_icon.dart';
import '../../core/ui/app_text_button.dart';
import '../../core/ui/blurred_circles_background.dart';
import '../../core/ui/header_bar/header_bar.dart';
import '../../core/ui/separator.dart';
import '../../core/utils/app_urls.dart';
import '../view_models/about_screen_view_model.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key, required this.viewModel});

  final AboutScreenViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlurredCirclesBackground(
        child: SafeArea(
          child: Column(
            children: [
              HeaderBar(title: context.localization.aboutLabel),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: Dimens.of(context).paddingScreenVertical,
                      horizontal: Dimens.of(context).paddingScreenHorizontal,
                    ),
                    child: Column(
                      spacing: Dimens.paddingVertical,
                      children: [
                        const Align(
                          alignment: Alignment.center,
                          child: AppIcon(size: 64),
                        ),
                        Text(
                          '${context.localization.aboutVersion} ${viewModel.clientInfo.appVersion} (${context.localization.aboutBuild} ${viewModel.clientInfo.buildNumber})',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Text(
                          '© ${DateTime.now().year} ${viewModel.clientInfo.appName}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const Separator(),
                        AppTextButton(
                          onPress: () => launchUrl(AppUrls.privacyPolicy),
                          label: context.localization.misc_privacyPolicy,
                          underline: true,
                          minimumSize: Size.zero,
                          shrinkWrap: true,
                        ),
                        AppTextButton(
                          onPress: () => launchUrl(AppUrls.termsAndConditions),
                          label: context.localization.misc_termsAndConditions,
                          underline: true,
                          minimumSize: Size.zero,
                          shrinkWrap: true,
                        ),
                        AppTextButton(
                          onPress: () => showLicensePage(context: context),
                          label: context.localization.aboutSourceLicenses,
                          underline: true,
                          minimumSize: Size.zero,
                          shrinkWrap: true,
                        ),
                        const Separator(),
                        AppTextButton(
                          onPress: () =>
                              launchUrl(AppUrls.supportEmailLaunchUri),
                          label: context.localization.misc_contactSupport,
                          underline: true,
                          minimumSize: Size.zero,
                          shrinkWrap: true,
                        ),
                        AppTextButton(
                          onPress: () => launchUrl(AppUrls.website),
                          label: context.localization.aboutVisitWebsite,
                          underline: true,
                          minimumSize: Size.zero,
                          shrinkWrap: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
