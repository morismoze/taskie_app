import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../../routing/routes.dart';
import '../../../core/l10n/l10n_extensions.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/dimens.dart';
import '../../../core/utils/constants.dart';
import '../view_models/app_bottom_navigation_bar_view_model.dart';

class AppBottomNavigationBar extends StatelessWidget {
  const AppBottomNavigationBar({super.key, required this.viewModel});

  final AppBottomNavigationBarViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListenableBuilder(
        listenable: viewModel,
        builder: (builderContext, child) {
          final rightPadding = viewModel.canPerformObjectiveCreation
              ? Dimens.paddingHorizontal * 1.75 + kAppBottomNavigationBarHeight
              : Dimens.paddingHorizontal;

          return Padding(
            padding: EdgeInsets.only(
              left: Dimens.paddingHorizontal,
              right: rightPadding,
              top: 0,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
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
          );
        },
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

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        GoRouter.of(
          context,
        ).go(Routes.tasks(workspaceId: viewModel.activeWorkspaceId));
      case 1:
        GoRouter.of(
          context,
        ).go(Routes.leaderboard(workspaceId: viewModel.activeWorkspaceId));
      case 2:
        GoRouter.of(
          context,
        ).go(Routes.goals(workspaceId: viewModel.activeWorkspaceId));
    }
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
