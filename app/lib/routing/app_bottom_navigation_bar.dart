import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../ui/core/l10n/l10n_extensions.dart';
import '../ui/core/theme/colors.dart';
import '../ui/core/theme/dimens.dart';
import '../ui/core/util/constants.dart';
import 'routes.dart';

class AppBottomNavigationBar extends StatelessWidget {
  const AppBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      padding: const EdgeInsets.only(
        left: Dimens.paddingHorizontal,
        right: Dimens.paddingHorizontal * 1.75 + kAppFloatingActionButtonSize,
        top: 0,
        bottom: 0,
      ),
      height: kAppFloatingActionButtonSize,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Theme(
          data: Theme.of(context).copyWith(
            splashFactory: NoSplash.splashFactory,
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
          ),
          child: BottomNavigationBar(
            showUnselectedLabels: false,
            backgroundColor: AppColors.purple1Light,
            unselectedItemColor: Theme.of(
              context,
            ).colorScheme.primary.withValues(alpha: 0.4),
            selectedFontSize: 10,
            currentIndex: _calculateSelectedIndex(context),
            onTap: (int idx) => _onItemTapped(idx, context),
            items: _getItems(context)
                .map(
                  (item) => BottomNavigationBarItem(
                    icon: FaIcon(item.$1, size: 18),
                    label: item.$2,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }

  static int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    return switch (location) {
      final path when path.contains(Routes.tasksRelative) => 0,
      final path when path.contains(Routes.leaderboard) => 1,
      final path when path.contains(Routes.goalsRelative) => 2,
      _ => 0,
    };
  }

  void _onItemTapped(int index, BuildContext context) async {
    if (context.mounted) {
      switch (index) {
        case 0:
          GoRouter.of(context).go(Routes.tasks);
        case 1:
          GoRouter.of(context).go(Routes.leaderboard);
        case 2:
          GoRouter.of(context).go(Routes.goals);
      }
    }
  }

  List<(IconData, String)> _getItems(BuildContext context) {
    return [
      (FontAwesomeIcons.house, context.localization.tasksLabel),
      (FontAwesomeIcons.trophy, context.localization.leaderboardLabel),
      (FontAwesomeIcons.solidFlag, context.localization.goalsLabel),
    ];
  }
}
