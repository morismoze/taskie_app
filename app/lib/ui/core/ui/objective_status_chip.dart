import 'package:flutter/material.dart';

import '../../../data/services/api/workspace/progress_status.dart';
import '../theme/dimens.dart';
import '../utils/extensions.dart';

class ObjectiveStatusChip extends StatelessWidget {
  const ObjectiveStatusChip({
    super.key,
    required this.status,
    required this.backgroundColor,
    required this.textColor,
  });

  final ProgressStatus status;
  final Color backgroundColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Badge(
      backgroundColor: backgroundColor,
      padding: const EdgeInsets.symmetric(
        vertical: Dimens.paddingVertical / 12,
        horizontal: Dimens.paddingHorizontal / 2.5,
      ),
      label: Text(
        status.l10n(context),
        style: Theme.of(context).textTheme.labelSmall!.copyWith(
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }
}
