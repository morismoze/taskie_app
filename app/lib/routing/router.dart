import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../data/repositories/auth/auth_state_repository.dart';
import '../data/repositories/workspace/workspace/workspace_repository.dart';
import '../ui/auth/sign_in/view_models/sign_in_viewmodel.dart';
import '../ui/auth/sign_in/widgets/sign_in_screen.dart';
import '../ui/entry/view_models/entry_screen_viewmodel.dart';
import '../ui/entry/widgets/entry_screen.dart';
import '../ui/goals_create/view_models/create_goal_screen_viewmodel.dart';
import '../ui/goals_create/widgets/create_goal_screen.dart';
import '../ui/navigation/app_bottom_navigation_bar/view_models/app_bottom_navigation_bar_view_model.dart';
import '../ui/navigation/app_drawer/view_models/app_drawer_viewmodel.dart';
import '../ui/navigation/app_shell_scaffold.dart';
import '../ui/preferences/view_models/preferences_screen_viewmodel.dart';
import '../ui/preferences/widgets/preferences_screen.dart';
import '../ui/tasks/view_models/tasks_screen_viewmodel.dart';
import '../ui/tasks/widgets/tasks_screen.dart';
import '../ui/tasks_create/view_models/create_task_screen_viewmodel.dart';
import '../ui/tasks_create/widgets/create_task_screen.dart';
import '../ui/workspace_create/view_models/create_workspace_screen_viewmodel.dart';
import '../ui/workspace_create/widgets/create_workspace_screen.dart';
import '../ui/workspace_create_initial/view_models/create_workspace_initial_screen_viewmodel.dart';
import '../ui/workspace_create_initial/widgets/create_workspace_initial_screen.dart';
import '../ui/workspace_settings/view_models/workspace_settings_screen_viewmodel.dart';
import '../ui/workspace_settings/widgets/workspace_settings_screen.dart';
import '../ui/workspace_users_management/view_models/workspace_users_management_screen_viewmodel.dart';
import '../ui/workspace_users_management/widgets/workspace_users_management_screen.dart';
import '../ui/workspace_users_management_create/view_models/create_workspace_user_screen_viewmodel.dart';
import '../ui/workspace_users_management_create/widgets/create_workspace_user_screen.dart';
import '../ui/workspace_users_management_guide/widgets/workspace_users_management_guide_screen.dart';
import '../ui/workspace_users_management_user_details/view_models/workspace_user_details_screen_view_model.dart';
import '../ui/workspace_users_management_user_details/widgets/workspace_user_details_screen.dart';
import '../ui/workspace_users_management_user_details_edit/view_models/workspace_user_details_edit_screen_view_model.dart';
import '../ui/workspace_users_management_user_details_edit/widgets/workspace_user_details_edit_screen.dart';
import 'routes.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);
final GlobalKey<StatefulNavigationShellState> _mainStatefulShellNavigatorKey =
    GlobalKey<StatefulNavigationShellState>(debugLabel: 'workspaceIdshell');

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
///     /StatefulShellRoute
///       /StatefulShelBranch
///         /tasks
///           /create (on root navigator)
///           /:id (on root navigator)
///       /StatefulShelBranch
///         /leaderboard
///       /StatefulShelBranch
///         /goals
///           /create (on root navigator)
///           /:id (on root navigator)
///     /users
///       /create
///       /guide
///     /settings
/// /preferences
GoRouter router({
  required AuthStateRepository authStateRepository,
  required WorkspaceRepository workspaceRepository,
}) => GoRouter(
  initialLocation: Routes.entry,
  debugLogDiagnostics: true,
  redirect: _redirect,
  refreshListenable: Listenable.merge([
    authStateRepository,
    workspaceRepository,
  ]),
  navigatorKey: _rootNavigatorKey,
  routes: [
    GoRoute(
      path: Routes.entry,
      builder: (context, state) {
        return EntryScreen(
          viewModel: EntryScreenViewModel(
            userRepository: context.read(),
            workspaceRepository: context.read(),
          ),
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
            StatefulShellRoute(
              key: _mainStatefulShellNavigatorKey,
              navigatorContainerBuilder: (context, navigationShell, children) {
                // IndexedStack is basically a stack which has all the StatefulShellBranch
                // and their subroutes in it, and on top of the stack will be a route defined
                // by navigationShell.currentIndex. Or to be more correct, IndexedStack holds
                // all Navigators represented by different StatefulShellBranches.
                return IndexedStack(
                  index: navigationShell.currentIndex,
                  children: children,
                );
              },
              builder: (context, state, navigationShell) {
                final workspaceId = state.pathParameters['workspaceId']!;

                return MultiProvider(
                  // Both of these view models are wrapped in providers, because we want to limit
                  // reinstantianting them on every navigation inside the shell route. Same keys for
                  // both ChangeNotifierProvider is okay since they are different due to the different
                  // generic type.
                  providers: [
                    ChangeNotifierProvider(
                      key: ValueKey(workspaceId),
                      create: (notifierContext) =>
                          AppBottomNavigationBarViewModel(
                            workspaceId: workspaceId,
                            rbacService: notifierContext.read(),
                          ),
                    ),
                    ChangeNotifierProvider(
                      key: ValueKey(workspaceId),
                      create: (notifierContext) => AppDrawerViewModel(
                        workspaceId: workspaceId,
                        workspaceRepository: notifierContext.read(),
                        refreshTokenUseCase: notifierContext.read(),
                        activeWorkspaceChangeUseCase: notifierContext.read(),
                      ),
                    ),
                  ],
                  child: AppShellScaffold(
                    workspaceId: workspaceId,
                    navigationShell: navigationShell,
                  ),
                );
              },
              branches: [
                StatefulShellBranch(
                  routes: [
                    GoRoute(
                      path: Routes.tasksRelative,
                      pageBuilder: (context, state) {
                        final workspaceId =
                            state.pathParameters['workspaceId']!;

                        return NoTransitionPage(
                          key: state.pageKey,
                          child: TasksScreen(
                            viewModel: TasksScreenViewModel(
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
                              viewModel: CreateTaskScreenViewmodel(
                                workspaceId: workspaceId,
                                workspaceTaskRepository: context.read(),
                                workspaceUserRepository: context.read(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                StatefulShellBranch(
                  routes: [
                    GoRoute(
                      path: Routes.leaderboardRelative,
                      pageBuilder: (context, state) {
                        return NoTransitionPage(
                          key: state.pageKey,
                          child: const Text('leaderboard'),
                        );
                      },
                    ),
                  ],
                ),
                StatefulShellBranch(
                  routes: [
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
                              viewModel: CreateGoalScreenViewmodel(
                                workspaceRepository: context.read(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            GoRoute(
              path: Routes.workspaceUsersRelative,
              builder: (context, state) {
                final workspaceId = state.pathParameters['workspaceId']!;

                return ChangeNotifierProvider<
                  WorkspaceUsersScreenManagementViewModel
                >(
                  key: ValueKey(workspaceId),
                  create: (context) => WorkspaceUsersScreenManagementViewModel(
                    workspaceId: workspaceId,
                    userRepository: context.read(),
                    workspaceUserRepository: context.read(),
                  ),
                  // Without the Builder here, reading `WorkspaceUsersScreenManagementViewModel`
                  // would result in an error saying its provider is not defined, and that's
                  // because the used `context` is not yet at that moment defined inside the
                  // scope of the `ChangeNotifierProvider<WorkspaceUsersScreenManagementViewModel>`
                  // provider. Builder helps to give a new `context` which at is inside the Provider
                  // scope. The end goal of this was to memoize the `WorkspaceUsersScreenManagementViewModel`
                  // view model, as there is no need for it to be instantiated on every route change.
                  //
                  // `create` and `child` evaluate at almost the same time, hence why without Builder
                  // `context` would not yet see the new InheritedWidget (Provider).
                  child: Builder(
                    builder: (context) => WorkspaceUsersManagementScreen(
                      viewModel: context
                          .watch<WorkspaceUsersScreenManagementViewModel>(),
                    ),
                  ),
                );
              },
              routes: [
                GoRoute(
                  path: Routes.workspaceUsersCreateRelative,
                  builder: (context, state) {
                    final workspaceId = state.pathParameters['workspaceId']!;

                    // We are not using the view model memoization here because we
                    // want the workspace invite repository call to fire everytime we
                    // land on this route, so the repository can check if the cached
                    // workspace invite is expired.
                    return CreateWorkspaceUserScreen(
                      viewModel: CreateWorkspaceUserScreenViewModel(
                        workspaceId: workspaceId,
                        workspaceRepository: context.read(),
                        workspaceInviteRepository: context.read(),
                        workspaceUserRepository: context.read(),
                        shareWorkspaceInviteLinkUseCase: context.read(),
                      ),
                    );
                  },
                ),
                GoRoute(
                  path: Routes.workspaceUsersGuideRelative,
                  builder: (context, state) {
                    return const WorkspaceUsersManagementGuideScreen();
                  },
                ),
                GoRoute(
                  path: ':workspaceUserId',
                  builder: (context, state) {
                    final workspaceId = state.pathParameters['workspaceId']!;
                    final workspaceUserId =
                        state.pathParameters['workspaceUserId']!;

                    // We are not using the view model memoization here because we
                    // want the user details repository call to fire everytime we
                    // land on this route, so we get fresh data for specific workspace
                    // user ID - this is important as Managers can edit workspace user
                    // data, and we are not listening to entire workspace user repository
                    // `users` listenable value on this route, as that would be unnecessary.
                    return WorkspaceUserDetailsScreen(
                      viewModel: WorkspaceUserDetailsScreenViewModel(
                        workspaceId: workspaceId,
                        workspaceUserId: workspaceUserId,
                        userRepository: context.read(),
                        workspaceUserRepository: context.read(),
                      ),
                    );
                  },
                  routes: [
                    GoRoute(
                      path: Routes.workspaceUsersEditUserDetailsRelative,
                      builder: (context, state) {
                        final workspaceId =
                            state.pathParameters['workspaceId']!;
                        final workspaceUserId =
                            state.pathParameters['workspaceUserId']!;

                        return WorkspaceUserDetailsEditScreen(
                          viewModel: WorkspaceUserDetailsEditScreenViewModel(
                            workspaceId: workspaceId,
                            workspaceUserId: workspaceUserId,
                            workspaceUserRepository: context.read(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
            GoRoute(
              path: Routes.workspaceSettingsRelative,
              builder: (context, state) {
                final workspaceId = state.pathParameters['workspaceId']!;

                return Provider<WorkspaceSettingsScreenViewmodel>(
                  key: ValueKey(workspaceId),
                  create: (context) => WorkspaceSettingsScreenViewmodel(
                    workspaceId: workspaceId,
                    workspaceRepository: context.read(),
                  ),
                  child: Builder(
                    builder: (context) => WorkspaceSettingsScreen(
                      viewModel: context
                          .watch<WorkspaceSettingsScreenViewmodel>(),
                    ),
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
          viewModel: PreferencesScreenViewModel(
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
