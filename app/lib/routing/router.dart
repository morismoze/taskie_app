import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../data/repositories/auth/auth_state_repository.dart';
import '../data/repositories/workspace/workspace/workspace_repository.dart';
import '../ui/auth/sign_in/view_models/sign_in_viewmodel.dart';
import '../ui/auth/sign_in/widgets/sign_in_screen.dart';
import '../ui/entry/view_models/entry_screen_viewmodel.dart';
import '../ui/entry/widgets/entry_screen.dart';
import '../ui/goals_create/view_models/create_goal_viewmodel.dart';
import '../ui/goals_create/widgets/create_goal_screen.dart';
import '../ui/navigation/app_shell_scaffold.dart';
import '../ui/navigation/combined_listeable.dart';
import '../ui/preferences/view_models/preferences_viewmodel.dart';
import '../ui/preferences/widgets/preferences_screen.dart';
import '../ui/tasks/view_models/tasks_viewmodel.dart';
import '../ui/tasks/widgets/tasks_screen.dart';
import '../ui/tasks_create/view_models/create_task_viewmodel.dart';
import '../ui/tasks_create/widgets/create_task_screen.dart';
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
///   /:workspaceId
///     /ShellRoute
///       /leaderboard
///       /invite
///       /tasks
///         /create (on root navigator)
///         /:id
///       /goals
///         /create (on root navigator)
///         /:id
GoRouter router({
  required AuthStateRepository authStateRepository,
  required WorkspaceRepository workspaceRepository,
}) => GoRouter(
  initialLocation: Routes.entry,
  debugLogDiagnostics: true,
  redirect: _redirect,
  refreshListenable: CombinedListenable([
    authStateRepository,
    workspaceRepository,
  ]),
  navigatorKey: _rootNavigatorKey,
  routes: [
    GoRoute(
      path: Routes.entry,
      builder: (context, state) {
        return EntryScreen(
          viewModel: EntryScreenViewModel(workspaceRepository: context.read()),
        );
      },
    ),
    GoRoute(
      path: Routes.login,
      builder: (context, state) {
        return SignInScreen(
          viewModel: SignInViewModel(signInUseCase: context.read()),
        );
      },
    ),
    GoRoute(
      path: Routes.workspacesRelative,
      builder: (_, _) => const SizedBox.shrink(),
      routes: [
        GoRoute(
          path: Routes.workspaceCreateInitialRelative,
          builder: (context, state) {
            return CreateWorkspaceInitialScreen(
              viewModel: CreateWorkspaceInitialScreenViewModel(
                workspaceRepository: context.read(),
                userRepository: context.read(),
                createWorkspaceUseCase: context.read(),
              ),
            );
          },
        ),
        GoRoute(
          path: Routes.workspaceCreateRelative,
          builder: (context, state) {
            return CreateWorkspaceScreen(
              viewModel: CreateWorkspaceScreenViewModel(
                userRepository: context.read(),
                workspaceRepository: context.read(),
                createWorkspaceUseCase: context.read(),
              ),
            );
          },
        ),
        GoRoute(
          path: ':workspaceId',
          builder: (_, _) => const SizedBox.shrink(),
          routes: [
            ShellRoute(
              navigatorKey: _shellNavigatorKey,
              builder:
                  (BuildContext context, GoRouterState state, Widget child) {
                    final workspaceId = state.pathParameters['workspaceId']!;

                    return AppShellScaffold(
                      key: ValueKey(workspaceId),
                      workspaceId: workspaceId,
                      child: child,
                    );
                  },
              routes: [
                GoRoute(
                  path: Routes.tasksRelative,
                  pageBuilder: (context, state) {
                    final workspaceId = state.pathParameters['workspaceId']!;

                    return NoTransitionPage(
                      key: state.pageKey,
                      child: TasksScreen(
                        viewModel: TasksViewModel(
                          workspaceId: workspaceId,
                          userRepository: context.read(),
                          workspaceTaskRepository: context.read(),
                        ),
                      ),
                    );
                  },
                  routes: [
                    GoRoute(
                      path: Routes.taskCreateRelative,
                      parentNavigatorKey: _rootNavigatorKey,
                      builder: (context, state) {
                        final workspaceId =
                            state.pathParameters['workspaceId']!;

                        return CreateTaskScreen(
                          viewModel: CreateTaskViewmodel(
                            workspaceId: workspaceId,
                            workspaceTaskRepository: context.read(),
                            workspaceUserRepository: context.read(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                GoRoute(
                  path: Routes.leaderboardRelative,
                  pageBuilder: (context, state) {
                    return NoTransitionPage(
                      key: state.pageKey,
                      child: const Text('leaderboard'),
                    );
                  },
                ),
                GoRoute(
                  path: Routes.goalsRelative,
                  pageBuilder: (context, state) {
                    return NoTransitionPage(
                      key: state.pageKey,
                      child: const Text('goals'),
                    );
                  },
                  routes: [
                    GoRoute(
                      path: Routes.goalCreateRelative,
                      parentNavigatorKey: _rootNavigatorKey,
                      builder: (context, state) {
                        return CreateGoalScreen(
                          viewModel: CreateGoalViewmodel(
                            workspaceRepository: context.read(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
            GoRoute(
              path: Routes.workspaceInviteRelative,
              builder: (context, state) {
                final workspaceId = state.pathParameters['workspaceId']!;

                return WorkspaceInviteScreen(
                  key: ValueKey(state.pageKey),
                  viewModel: WorkspaceInviteViewModel(
                    workspaceId: workspaceId,
                    workspaceInviteRepository: context.read(),
                  ),
                );
              },
            ),
            GoRoute(
              path: Routes.workspaceSettingsRelative,
              builder: (context, state) {
                final workspaceId = state.pathParameters['workspaceId']!;

                return WorkspaceSettingsScreen(
                  key: ValueKey(state.pageKey),
                  viewModel: WorkspaceSettingsViewmodel(
                    workspaceId: workspaceId,
                    workspaceRepository: context.read(),
                  ),
                );
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
  // if the user is not part of any workspace anymore (e.g. left all workspaces),
  // we need to redirect the user to workspace initial creation screen
  final hasNoWorkspaces = context.read<WorkspaceRepository>().hasNoWorkspaces;
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

  if (hasNoWorkspaces != null && hasNoWorkspaces) {
    return Routes.workspaceCreateInitial;
  }

  // no need to redirect
  return null;
}
