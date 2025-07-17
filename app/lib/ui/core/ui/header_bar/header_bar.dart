import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../theme/dimens.dart';
import 'app_header_action_button.dart';

class HeaderBar extends StatelessWidget {
  const HeaderBar({super.key, required this.title, this.actions});

  final String title;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: false,
      child: Padding(
        padding: EdgeInsets.only(
          left: Dimens.of(context).paddingScreenHorizontal,
          right: Dimens.of(context).paddingScreenHorizontal,
          top: Dimens.paddingVertical,
          bottom: Dimens.paddingVertical / 2,
        ),
        child: Row(
          mainAxisAlignment: actions != null
              ? MainAxisAlignment.spaceBetween
              : MainAxisAlignment.start,
          children: [
            const AppHeaderActionButton(iconData: FontAwesomeIcons.arrowLeft),
            if (actions == null) const SizedBox(width: 30),
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            if (actions != null) Row(spacing: 2, children: actions!),
          ],
        ),
      ),
    );
  }
}
