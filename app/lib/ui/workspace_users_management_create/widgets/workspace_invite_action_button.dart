import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/theme.dart';

class WorkspaceInviteActionButton extends StatelessWidget {
  const WorkspaceInviteActionButton({
    super.key,
    required this.onTap,
    required this.iconData,
  });

  final void Function() onTap;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: AppTheme.fieldHeight,
        width: AppTheme.fieldHeight,
        padding: EdgeInsets.all(AppTheme.fieldInnerPadding),
        decoration: BoxDecoration(
          color: AppColors.fieldFillColor,
          borderRadius: BorderRadius.circular(AppTheme.fieldBorderRadius),
        ),
        child: Center(
          child: FaIcon(iconData, color: AppColors.grey2, size: 18),
        ),
      ),
    );
  }
}
