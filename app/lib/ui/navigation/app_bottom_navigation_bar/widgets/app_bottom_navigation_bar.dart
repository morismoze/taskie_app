import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../routing/routes.dart';
import '../../../core/l10n/l10n_extensions.dart';
import '../../../core/theme/colors.dart';
import '../../../core/ui/app_avatar.dart';
import '../../app_fab/widgets/app_floating_action_button.dart';
import '../view_models/app_bottom_navigation_bar_view_model.dart';

const double kAppBottomNavigationBarHeight = 58.0;
const double kAppBottomNavigationBarBorderRadius = 40.0;

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
    final currentIndex = _getCurrentTabIndex(context);

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(kAppBottomNavigationBarBorderRadius),
        topRight: Radius.circular(kAppBottomNavigationBarBorderRadius),
      ),
      child: BottomAppBar(
        height: kAppBottomNavigationBarHeight,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        shape: canCreateObjective ? const CircularNotchedRectangle() : null,
        color: AppColors.purple1Light,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _buildTabItem(
              context: context,
              icon: FontAwesomeIcons.house,
              label: context.localization.bottomNavigationBarTasksLabel,
              isActive: currentIndex == 0,
              onPressed: () => navigationShell.goBranch(0),
            ),
            _buildTabItem(
              context: context,
              icon: FontAwesomeIcons.solidFlag,
              label: context.localization.bottomNavigationBarGoalsLabel,
              isActive: currentIndex == 2,
              onPressed: () => navigationShell.goBranch(2),
            ),
            if (canCreateObjective)
              const SizedBox(width: kAppFloatingActionButtonSize),
            _buildTabItem(
              context: context,
              icon: FontAwesomeIcons.trophy,
              label: context.localization.bottomNavigationBarLeaderboardLabel,
              isActive: currentIndex == 1,
              onPressed: () => navigationShell.goBranch(1),
            ),
            _buildAvatarTabItem(
              context: context,
              isActive: currentIndex == 3,
              onPressed: () => navigationShell.goBranch(3),
            ),
          ],
        ),
      ),
    );
  }

  int _getCurrentTabIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    return switch (location) {
      final path when path.contains(Routes.tasksRelative) => 0,
      final path when path.contains(Routes.leaderboardRelative) => 1,
      final path when path.contains(Routes.goalsRelative) => 2,
      _ => 0,
    };
  }

  Widget _buildTabItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onPressed,
  }) {
    final color = isActive
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.primary.withValues(alpha: 0.4);

    return Expanded(
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Column(
            spacing: 4,
            mainAxisSize: MainAxisSize.min,
            children: [
              FaIcon(icon, size: 16, color: color),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  color: color,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarTabItem({
    required BuildContext context,
    required bool isActive,
    required VoidCallback onPressed,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Column(
            spacing: 4,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: isActive
                    ? BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2,
                        ),
                      )
                    : null,
                child: AppAvatar(
                  hashString: viewModel.user!.id,
                  firstName: viewModel.user!.firstName,
                  imageUrl: viewModel.user!.profileImageUrl,
                  size: 20,
                ),
              ),
              Text(
                context.localization.misc_profile,
                style: TextStyle(
                  fontSize: 10,
                  color: isActive
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.4),
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
