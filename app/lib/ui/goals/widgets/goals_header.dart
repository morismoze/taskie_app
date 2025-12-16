import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../routing/routes.dart';
import '../../core/l10n/l10n_extensions.dart';
import '../../core/theme/dimens.dart';
import '../../core/ui/header_bar/app_header_action_button.dart';
import '../view_models/goals_screen_viewmodel.dart';

class GoalsHeader extends StatelessWidget {
  const GoalsHeader({super.key, required this.viewModel});

  final GoalsScreenViewmodel viewModel;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Dimens.of(context).paddingScreenHorizontal,
          vertical: Dimens.of(context).paddingScreenVertical / 2,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              context.localization.goalsLabel,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            AppHeaderActionButton(
              iconData: FontAwesomeIcons.question,
              onTap: () => context.push(
                Routes.goalsGuide(workspaceId: viewModel.activeWorkspaceId),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
