import 'package:flutter/material.dart';

import '../../../data/services/api/user/models/response/user_response.dart';
import '../theme/colors.dart';
import '../theme/dimens.dart';
import '../utils/extensions.dart';

class RoleChip extends StatelessWidget {
  const RoleChip({super.key, required this.role});

  final WorkspaceRole role;

  @override
  Widget build(BuildContext context) {
    final roleChipBackgroundColor = role == WorkspaceRole.manager
        ? AppColors.purple1Light
        : AppColors.green1Light;
    final roleChipTextColor = role == WorkspaceRole.manager
        ? Theme.of(context).colorScheme.primary
        : AppColors.green1;

    return Chip(
      padding: const EdgeInsets.symmetric(
        vertical: 0,
        horizontal: Dimens.paddingHorizontal / 8,
      ),
      side: BorderSide.none,
      backgroundColor: roleChipBackgroundColor,
      label: Text(
        role.l10n(context),
        style: Theme.of(context).textTheme.labelMedium!.copyWith(
          fontWeight: FontWeight.bold,
          color: roleChipTextColor,
        ),
      ),
    );
  }
}
