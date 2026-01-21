import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../../routing/routes.dart';
import '../../../core/l10n/l10n_extensions.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/dimens.dart';
import '../../../core/ui/app_text_button.dart';
import '../view_models/app_drawer_view_model.dart';
import 'about_button.dart';

class Footer extends StatelessWidget {
  const Footer({super.key, required this.viewModel});

  final AppDrawerViewModel viewModel;

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
        const SizedBox(height: Dimens.paddingVertical / 4),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Dimens.paddingHorizontal,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextButton(
                onPress: () {
                  context.push(Routes.workspaceCreate);
                },
                label: context.localization.appDrawerCreateNewWorkspace,
                leadingIcon: FontAwesomeIcons.plus,
              ),
              AboutButton(viewModel: viewModel),
            ],
          ),
        ),
      ],
    );
  }
}
