import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../theme/colors.dart';

class AppHeaderActionButton extends StatelessWidget {
  const AppHeaderActionButton({super.key, required this.iconData, this.onTap});

  final IconData iconData;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: 40,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.grey1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {
            if (onTap != null) {
              onTap!();
            } else {
              context.pop();
            }
          },
          child: Center(
            child: FaIcon(
              iconData,
              size: 20,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
      ),
    );
  }
}
