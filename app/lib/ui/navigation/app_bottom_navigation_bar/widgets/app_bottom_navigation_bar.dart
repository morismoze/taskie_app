import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../domain/models/user.dart';
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
            _TabItem(
              icon: FontAwesomeIcons.house,
              label: context.localization.bottomNavigationBarTasksLabel,
              isActive: currentIndex == 0,
              onPressed: () => _navigateToBranch(0),
            ),
            _TabItem(
              icon: FontAwesomeIcons.solidFlag,
              label: context.localization.goalsLabel,
              isActive: currentIndex == 2,
              onPressed: () => _navigateToBranch(1),
            ),
            if (canCreateObjective)
              const SizedBox(width: kAppFloatingActionButtonSize),
            _TabItem(
              icon: FontAwesomeIcons.trophy,
              label: context.localization.leaderboardLabel,
              isActive: currentIndex == 1,
              onPressed: () => _navigateToBranch(2),
            ),
            _AvatarTabItem(
              isActive: currentIndex == 3,
              onPressed: () => _navigateToBranch(3),
              user: viewModel.user!,
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToBranch(int index) {
    if (viewModel.needsReset(index)) {
      // Workspace was changed - we need to reset the state of the branch
      navigationShell.goBranch(index, initialLocation: true);
      viewModel.markVisited(index);
    } else {
      // Workspace was not changed - keep the branch's state
      navigationShell.goBranch(index);
    }
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
}

class _TabItem extends StatelessWidget {
  const _TabItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
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
}

class _AvatarTabItem extends StatelessWidget {
  const _AvatarTabItem({
    required this.isActive,
    required this.onPressed,
    required this.user,
  });

  final bool isActive;
  final VoidCallback onPressed;
  final User user;

  @override
  Widget build(BuildContext context) {
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
                  hashString: user.id,
                  firstName: user.firstName,
                  imageUrl: user.profileImageUrl,
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
