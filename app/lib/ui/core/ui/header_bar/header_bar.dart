import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

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
          top: Dimens.of(context).paddingScreenVertical,
          bottom: Dimens.of(context).paddingScreenVertical / 2,
        ),
        child: Row(
          children: [
            AppHeaderActionButton(
              iconData: FontAwesomeIcons.arrowLeft,
              onTap: () => context.pop(),
            ),
            const SizedBox(width: 30),
            Expanded(
              child: Text(title, style: Theme.of(context).textTheme.titleLarge),
            ),
            if (actions != null) ...[
              const SizedBox(width: 15),
              Row(spacing: 8, children: actions!),
            ],
          ],
        ),
      ),
    );
  }
}
