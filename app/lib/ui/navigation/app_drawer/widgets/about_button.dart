import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../config/environment/env.dart';
import '../../../core/l10n/l10n_extensions.dart';
import '../../../core/theme/dimens.dart';
import '../../../core/ui/app_dialog.dart';
import '../../../core/ui/app_icon.dart';
import '../../../core/ui/app_outlined_button.dart';
import '../../../core/ui/app_text_button.dart';
import '../../../core/ui/separator.dart';
import '../view_models/app_drawer_viewmodel.dart';

class AboutButton extends StatelessWidget {
  const AboutButton({super.key, required this.viewModel});

  final AppDrawerViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return AppTextButton(
      onPress: () {
        _openAboutDialog(context);
      },
      label: context.localization.appDrawerAbout,
      leadingIcon: FontAwesomeIcons.circleInfo,
    );
  }

  void _openAboutDialog(BuildContext context) {
    AppDialog.show(
      context: context,
      title: Text(
        viewModel.clientInfo.appName,
        style: Theme.of(context).textTheme.titleLarge,
      ),
      content: Column(
        spacing: Dimens.paddingVertical,
        children: [
          const Align(alignment: Alignment.center, child: AppIcon(size: 64)),
          Text(
            'Version ${viewModel.clientInfo.appVersion} (Build ${viewModel.clientInfo.buildNumber})',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            '© ${DateTime.now().year} ${viewModel.clientInfo.appName}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const Separator(),
          AppTextButton(
            onPress: () =>
                launchUrl(Uri.parse('${Env.websiteBaseUrl}/privacy-policy')),
            label: context.localization.misc_privacyPolicy,
            underline: true,
            minimumSize: Size.zero,
            shrinkWrap: true,
          ),
          AppTextButton(
            onPress: () => launchUrl(
              Uri.parse('${Env.websiteBaseUrl}/terms-and-conditions'),
            ),
            label: context.localization.misc_termsAndConditions,
            underline: true,
            minimumSize: Size.zero,
            shrinkWrap: true,
          ),
          AppTextButton(
            onPress: () => showLicensePage(context: context),
            label: context.localization.appDrawerAboutSourceLicenses,
            underline: true,
            minimumSize: Size.zero,
            shrinkWrap: true,
          ),
          const Separator(),
          AppTextButton(
            onPress: () => launchUrl(Uri.parse('mailto:support@taskieapp.xyz')),
            label: context.localization.misc_contactSupport,
            underline: true,
            minimumSize: Size.zero,
            shrinkWrap: true,
          ),
          AppTextButton(
            onPress: () => launchUrl(Uri.parse(Env.websiteBaseUrl)),
            label: context.localization.appDrawerAboutVisitWebsite,
            underline: true,
            minimumSize: Size.zero,
            shrinkWrap: true,
          ),
          AppOutlinedButton(
            onPress: () => context.pop(),
            label: context.localization.misc_cancel,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ],
      ),
    );
  }
}
