import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../../routing/routes.dart';
import '../../l10n/l10n_extensions.dart';
import '../../theme/colors.dart';

class AppBottomNavigationBar extends StatelessWidget {
  const AppBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    final items = _getItems(context);

    return Theme(
      data: Theme.of(context).copyWith(
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
      ),
      child: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.grey3, width: 0.25)),
        ),
        child: BottomNavigationBar(
          showUnselectedLabels: false,
          backgroundColor: Theme.of(context).colorScheme.onSecondary,
          unselectedItemColor: AppColors.grey3,
          selectedFontSize: 10,
          currentIndex: _calculateSelectedIndex(context),
          onTap: (int idx) => _onItemTapped(idx, context),
          items: items
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
    );
  }

  static int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    return switch (location) {
      final path when path.startsWith(Routes.tasks) => 0,
      final path when path.startsWith(Routes.leaderboard) => 1,
      final path when path.startsWith(Routes.goals) => 2,
      _ => 0,
    };
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        GoRouter.of(context).go(Routes.tasks);
      case 1:
        GoRouter.of(context).go(Routes.leaderboard);
      case 2:
        GoRouter.of(context).go(Routes.goals);
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
