import 'package:flutter/material.dart';

import '../../core/l10n/l10n_extensions.dart';
import '../../core/theme/dimens.dart';
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
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
    );
  }
}
