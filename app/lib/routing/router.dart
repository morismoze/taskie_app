import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../data/repositories/auth/auth_state_repository.dart';
import '../ui/auth/sign_in/view_models/sign_in_viewmodel.dart';
import '../ui/auth/sign_in/widgets/sign_in_screen.dart';
import '../ui/splash/view_models/splash_viewmodel.dart';
import '../ui/splash/widgets/splash_screen.dart';
import '../ui/tasks/view_models/tasks_viewmodel.dart';
import '../ui/tasks/widgets/tasks_screen.dart';
import '../ui/workspaces/view_models/initial_create_workspace_viewmodel.dart';
import '../ui/workspaces/widgets/initial_create_workspace_screen.dart';
import 'routes.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

/// Top go_router entry point.
///
/// Listens to changes in [AuthStateRepository] to redirect the user
/// to /login when the user logs out.
GoRouter router(AuthStateRepository authStateRepository) => GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: Routes.splash,
  debugLogDiagnostics: true,
  redirect: _redirect,
  refreshListenable: authStateRepository,
  routes: [
    GoRoute(
      path: Routes.splash,
      builder: (context, state) {
        return SplashScreen(
          viewModel: SplashViewModel(authRepository: context.read()),
        );
      },
    ),
    GoRoute(
      path: Routes.login,
      builder: (context, state) {
        return SignInScreen(
          viewModel: SignInViewModel(authRepository: context.read()),
        );
      },
    ),
    GoRoute(
      path: Routes.initialCreateWorkspace,
      builder: (context, state) {
        return InitialCreateWorkspaceScreen(
          viewModel: InitialWorkspacesViewModel(authRepository: context.read()),
        );
      },
    ),
    GoRoute(
      path: Routes.tasks,
      builder: (context, state) {
        return TasksScreen(
          viewModel: TasksViewModel(authRepository: context.read()),
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
    return Routes.tasks;
  }

  // no need to redirect
  return null;
}
