import 'package:flutter/material.dart';

import '../../../core/l10n/l10n_extensions.dart';
import '../../../core/theme/dimens.dart';
import 'unassigned_avatar.dart';

class UnassignedLabel extends StatelessWidget {
  const UnassignedLabel({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: Dimens.paddingHorizontal / 2,
      mainAxisSize: MainAxisSize.min,
      children: [
        const UnassignedAvatar(),
        Text(
          context.localization.tasksUnassigned,
          style: Theme.of(context).textTheme.labelLarge,
        ),
      ],
    );
  }
}
