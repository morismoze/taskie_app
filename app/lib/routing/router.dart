import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../data/repositories/auth/auth_state_repository.dart';
import '../ui/auth/sign_in/view_models/sign_in_viewmodel.dart';
import '../ui/auth/sign_in/widgets/sign_in_screen.dart';
import '../ui/core/ui/navigation/app_shell_scaffold.dart';
import '../ui/entry/view_models/entry_viewmodel.dart';
import '../ui/entry/widgets/entry_screen.dart';
import '../ui/tasks/view_models/tasks_viewmodel.dart';
import '../ui/tasks/widgets/tasks_screen.dart';
import '../ui/workspaces/view_models/create_workspace_viewmodel.dart';
import '../ui/workspaces/widgets/create_workspace_screen.dart';
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
      path: Routes.createWorkspace,
      builder: (context, state) {
        return CreateWorkspaceScreen(
          viewModel: CreateWorkspaceViewModel(
            workspaceRepository: context.read(),
            userRepository: context.read(),
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
          path: Routes.tasks,
          pageBuilder: (context, state) {
            return NoTransitionPage(
              child: TasksScreen(
                viewModel: TasksViewModel(userRepository: context.read()),
              ),
            );
          },
        ),
        GoRoute(
          path: Routes.leaderboard,
          pageBuilder: (context, state) {
            return const NoTransitionPage(child: Text('goals'));
          },
        ),
        GoRoute(
          path: Routes.goals,
          pageBuilder: (context, state) {
            return const NoTransitionPage(child: Text('goals'));
          },
        ),
      ],
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
