import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../routing/routes.dart';
import '../../core/l10n/l10n_extensions.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/dimens.dart';
import '../../core/ui/app_text_button.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(
          height: 10,
          thickness: 1,
          indent: 0,
          endIndent: 0,
          color: AppColors.grey1,
        ),
        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Dimens.paddingHorizontal,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextButton(
                onPress: () {
                  Navigator.pop(context);
                  context.push(Routes.createWorkspace);
                },
                label: context.localization.appDrawerCreateNewWorkspace,
                leadingIcon: FontAwesomeIcons.plus,
              ),
              AppTextButton(
                onPress: () {
                  Navigator.pop(context);
                  context.push(Routes.preferences);
                },
                label: context.localization.appDrawerPreferences,
                leadingIcon: FontAwesomeIcons.gear,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
