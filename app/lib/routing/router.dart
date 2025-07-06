import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../data/repositories/auth/auth_state_repository.dart';
import '../ui/auth/sign_in/view_models/sign_in_viewmodel.dart';
import '../ui/auth/sign_in/widgets/sign_in_screen.dart';
import '../ui/core/ui/navigation/app_shell_scaffold.dart';
import '../ui/entry/view_models/entry_viewmodel.dart';
import '../ui/entry/widgets/entry_screen.dart';
import '../ui/preferences/view_models/preferences_viewmodel.dart';
import '../ui/preferences/widgets/preferences_screen.dart';
import '../ui/tasks/view_models/tasks_viewmodel.dart';
import '../ui/tasks/widgets/tasks_screen.dart';
import '../ui/workspace_create/view_models/create_workspace_viewmodel.dart';
import '../ui/workspace_create/widgets/create_workspace_screen.dart';
import '../ui/workspace_create_initial/view_models/create_workspace_initial_viewmodel.dart';
import '../ui/workspace_create_initial/widgets/create_workspace_initial_screen.dart';
import '../ui/workspace_invite/view_models/workspace_invite_viewmodel.dart';
import '../ui/workspace_invite/widgets/workspace_invite_screen.dart';
import '../ui/workspace_settings/view_models/workspace_settings_viewmodel.dart';
import '../ui/workspace_settings/widgets/workspace_settings_screen.dart';
import 'routes.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'shell',
);

/// Top go_router entry point.
///
/// Listens to changes in [AuthStateRepository] to redirect the user
/// to /login when the user logs out.
///
/// Routes hierarchy:
/// /login
/// /entry
/// /workspaces
///   /create/initial
///   /create
///   /:id
///     /leaderboard
///     /invite
///     /tasks
///       /:id
///     /goals
///       /:id
GoRouter router(AuthStateRepository authStateRepository) => GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: Routes.entry,
  debugLogDiagnostics: true,
  redirect: _redirect,
  refreshListenable: authStateRepository,
  routes: [
    GoRoute(
      path: Routes.login,
      builder: (context, state) {
        return SignInScreen(
          viewModel: SignInViewModel(signInUseCase: context.read()),
        );
      },
    ),
    GoRoute(
      path: Routes.entry,
      builder: (context, state) {
        return EntryScreen(
          viewModel: EntryViewModel(workspaceRepository: context.read()),
        );
      },
    ),
    GoRoute(
      path: Routes.workspacesRelative,
      builder: (context, state) => const SizedBox.shrink(),
      routes: [
        GoRoute(
          path: 'create/initial',
          builder: (context, state) {
            return CreateWorkspaceInitialScreen(
              viewModel: CreateWorkspaceInitialViewModel(
                workspaceRepository: context.read(),
                userRepository: context.read(),
                refreshTokenUseCase: context.read(),
              ),
            );
          },
        ),
        GoRoute(
          path: 'create',
          builder: (context, state) {
            return CreateWorkspaceScreen(
              viewModel: CreateWorkspaceViewModel(
                userRepository: context.read(),
                workspaceRepository: context.read(),
                refreshTokenUseCase: context.read(),
              ),
            );
          },
        ),
        GoRoute(
          path: ':id/invite',
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            final viewModel = WorkspaceInviteViewModel(
              workspaceRepository: context.read(),
            );

            // Initiate new invite link fetch when opening workspace invite screen
            viewModel.createInviteLink.execute(id);

            return WorkspaceInviteScreen(viewModel: viewModel);
          },
        ),
        GoRoute(
          path: ':id/settings',
          builder: (context, state) {
            return WorkspaceSettingsScreen(
              viewModel: WorkspaceSettingsViewmodel(
                workspaceRepository: context.read(),
              ),
            );
          },
        ),
        ShellRoute(
          navigatorKey: _shellNavigatorKey,
          builder: (BuildContext context, GoRouterState state, Widget child) {
            return AppShellScaffold(child: child);
          },
          routes: [
            GoRoute(
              path: ':id/tasks',
              pageBuilder: (context, state) {
                return NoTransitionPage(
                  child: TasksScreen(
                    viewModel: TasksViewModel(
                      userRepository: context.read(),
                      workspaceRepository: context.read(),
                    ),
                  ),
                );
              },
            ),
            GoRoute(
              path: ':id/leaderboard',
              pageBuilder: (context, state) {
                return const NoTransitionPage(child: Text('leaderboard'));
              },
            ),
            GoRoute(
              path: ':id/goals',
              pageBuilder: (context, state) {
                return const NoTransitionPage(child: Text('goals'));
              },
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: Routes.preferences,
      builder: (context, state) {
        return PreferencesScreen(
          viewModel: PreferencesViewModel(
            preferencesRepository: context.read(),
          ),
        );
      },
    ),
  ],
);

Future<String?> _redirect(BuildContext context, GoRouterState state) async {
  // if the user is not logged in, they need to login
  final loggedIn = await context.read<AuthStateRepository>().isAuthenticated;
  final loggingIn = state.matchedLocation == Routes.login;

  if (!loggedIn) {
    return Routes.login;
  }

  // if the user is logged in but still on the login page, send them to the initial route
  if (loggingIn) {
    return Routes.entry;
  }

  // no need to redirect
  return null;
}
