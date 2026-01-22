import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../domain/models/user.dart';
import '../../../../routing/routes.dart';
import '../../../core/l10n/l10n_extensions.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/dimens.dart';
import '../../../core/ui/app_avatar.dart';
import '../../../core/ui/app_modal_bottom_sheet.dart';
import '../../../user_profile/widgets/user_profile.dart';
import '../../app_fab/widgets/app_floating_action_button.dart';
import '../view_models/app_bottom_navigation_bar_view_model.dart';

const double kAppBottomNavigationBarHeight = 58.0;
const double kAppBottomNavigationBarBorderRadius = 40.0;
const int kTasksTabIndex = 0;
const int _kGoalsTabIndex = 1;
const int _kLeaderboardTabIndex = 2;

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
        padding: const EdgeInsets.symmetric(
          vertical: Dimens.paddingVertical / 3,
          horizontal: Dimens.paddingHorizontal * 1.25,
        ),
        shape: canCreateObjective ? const CircularNotchedRectangle() : null,
        color: AppColors.purple1Light,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _TabItem(
              icon: FontAwesomeIcons.house,
              label: context.localization.bottomNavigationBarTasksLabel,
              isActive: currentIndex == kTasksTabIndex,
              onPressed: () => _navigateToBranch(kTasksTabIndex, context),
            ),
            _TabItem(
              icon: FontAwesomeIcons.solidFlag,
              label: context.localization.goalsLabel,
              isActive: currentIndex == _kGoalsTabIndex,
              onPressed: () => _navigateToBranch(_kGoalsTabIndex, context),
            ),
            if (canCreateObjective)
              const SizedBox(width: kAppFloatingActionButtonSize),
            _TabItem(
              icon: FontAwesomeIcons.trophy,
              label: context.localization.leaderboardLabel,
              isActive: currentIndex == _kLeaderboardTabIndex,
              onPressed: () =>
                  _navigateToBranch(_kLeaderboardTabIndex, context),
            ),
            _AvatarTabItem(
              onPressed: () => _openUserProfile(context),
              user: viewModel.user!,
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToBranch(int index, BuildContext context) {
    if (viewModel.needsReset(index)) {
      // Workspace was changed - we need to reset the state of the branch

      // Tasks tab does not need a resetKey because it is the default entry point.
      // When the workspaceId changes, the parent route rebuilds, destroying the
      // entire StatefulShellRoute. The new Shell automatically builds the Tasks
      // screen from scratch as its initial active route.
      //
      // For other tabs (Goals, Leaderboard), we pass 'resetKey' (via extra) to
      // ensure that when we switch to them using context.go, GoRouter treats
      // them as completely new page instances (via unique ValueKey in routes),
      // bypassing any potential internal caching or soft-switching mechanisms.
      final resetKey = DateTime.now().millisecondsSinceEpoch;
      switch (index) {
        case kTasksTabIndex:
          context.go(Routes.tasks(workspaceId: viewModel.activeWorkspaceId));
        case _kGoalsTabIndex:
          context.go(
            Routes.goals(workspaceId: viewModel.activeWorkspaceId),
            extra: resetKey,
          );
        case _kLeaderboardTabIndex:
          context.go(
            Routes.leaderboard(workspaceId: viewModel.activeWorkspaceId),
            extra: resetKey,
          );
      }
      viewModel.markVisited(index);
    } else {
      // Workspace was not changed - keep the branch's state
      navigationShell.goBranch(index);
    }
  }

  void _openUserProfile(BuildContext context) {
    AppModalBottomSheet.show(
      context: context,
      isDetached: true,
      child: UserProfile(viewModel: context.read()),
    );
  }

  int _getCurrentTabIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    return switch (location) {
      final path when path.contains(Routes.tasksRelative) => kTasksTabIndex,
      final path when path.contains(Routes.goalsRelative) => _kGoalsTabIndex,
      final path when path.contains(Routes.leaderboardRelative) =>
        _kLeaderboardTabIndex,
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
  const _AvatarTabItem({required this.onPressed, required this.user});

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
              AppAvatar(
                hashString: user.id,
                firstName: user.firstName,
                imageUrl: user.profileImageUrl,
                size: 20,
              ),
              Text(
                context.localization.misc_profile,
                style: TextStyle(
                  fontSize: 10,
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.4),
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
