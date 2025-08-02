import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../routing/routes.dart';
import '../../../core/l10n/l10n_extensions.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/dimens.dart';
import '../view_models/app_bottom_navigation_bar_view_model.dart';

const double kAppBottomNavigationBarHeight = 56.0;
const double kAppBottomNavigationBarBorderRadius = 15.0;

class AppBottomNavigationBar extends StatelessWidget {
  const AppBottomNavigationBar({
    super.key,
    required this.viewModel,
    required this.navigationShell,
  });

  final AppBottomNavigationBarViewModel viewModel;
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final canCreateObjective = context.select(
      (AppBottomNavigationBarViewModel vm) => vm.canPerformObjectiveCreation,
    );
    final rightPadding = canCreateObjective
        ? Dimens.paddingHorizontal * 1.75 + kAppBottomNavigationBarHeight
        : Dimens.paddingHorizontal;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: Dimens.paddingHorizontal,
          right: rightPadding,
          top: 0,
          bottom: 0,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(
            kAppBottomNavigationBarBorderRadius,
          ),
          child: BottomNavigationBar(
            showUnselectedLabels: false,
            backgroundColor: AppColors.purple1Light,
            unselectedItemColor: Theme.of(
              context,
            ).colorScheme.primary.withValues(alpha: 0.4),
            selectedFontSize: 10,
            currentIndex: _calculateSelectedIndex(context),
            onTap: (index) => navigationShell.goBranch(index),
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

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    return switch (location) {
      final path when path.contains(Routes.tasksRelative) => 0,
      final path when path.contains(Routes.leaderboardRelative) => 1,
      final path when path.contains(Routes.goalsRelative) => 2,
      _ => 0,
    };
  }

  List<(IconData, String)> _getItems(BuildContext context) {
    return [
      (
        FontAwesomeIcons.house,
        context.localization.bottomNavigationBarTasksLabel,
      ),
      (
        FontAwesomeIcons.trophy,
        context.localization.bottomNavigationBarLeaderboardLabel,
      ),
      (
        FontAwesomeIcons.solidFlag,
        context.localization.bottomNavigationBarGoalsLabel,
      ),
    ];
  }
}
