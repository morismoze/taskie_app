import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../routing/routes.dart';
import '../theme/dimens.dart';
import 'app_header_action_button.dart';

class HeaderBar extends StatelessWidget {
  const HeaderBar({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: false,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Dimens.of(context).paddingScreenHorizontal,
          vertical: Dimens.paddingVertical,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const AppHeaderActionButton(iconData: FontAwesomeIcons.arrowLeft),
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            AppHeaderActionButton(
              iconData: FontAwesomeIcons.house,
              onTap: () {
                context.go(Routes.tasksRelative);
              },
            ),
          ],
        ),
      ),
    );
  }
}
