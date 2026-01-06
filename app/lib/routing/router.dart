import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../data/repositories/auth/auth_state_repository.dart';
import '../data/repositories/workspace/workspace/workspace_repository.dart';
import '../ui/auth/sign_in/view_models/sign_in_viewmodel.dart';
import '../ui/auth/sign_in/widgets/sign_in_screen.dart';
import '../ui/entry/view_models/entry_screen_viewmodel.dart';
import '../ui/entry/widgets/entry_screen.dart';
import '../ui/goals/view_models/goals_screen_viewmodel.dart';
import '../ui/goals/widgets/goals_screen.dart';
import '../ui/goals_create/view_models/create_goal_screen_viewmodel.dart';
import '../ui/goals_create/widgets/create_goal_screen.dart';
import '../ui/goals_details/view_models/goal_details_screen_view_model.dart';
import '../ui/goals_details/widgets/goal_details_screen.dart';
import '../ui/goals_details_edit/view_models/goal_details_edit_screen_view_model.dart';
import '../ui/goals_details_edit/widgets/goal_details_edit_screen.dart';
import '../ui/goals_guide/widgets/goals_guide_screen.dart';
import '../ui/leaderboard/view_models/leaderboard_screen_view_model.dart';
import '../ui/leaderboard/widgets/leaderboard_screen.dart';
import '../ui/navigation/app_bottom_navigation_bar/view_models/app_bottom_navigation_bar_view_model.dart';
import '../ui/navigation/app_drawer/view_models/app_drawer_viewmodel.dart';
import '../ui/navigation/app_shell_scaffold.dart';
import '../ui/navigation/back_button_handler.dart';
import '../ui/preferences/view_models/preferences_screen_viewmodel.dart';
import '../ui/preferences/widgets/preferences_screen.dart';
import '../ui/tasks/view_models/tasks_screen_viewmodel.dart';
import '../ui/tasks/widgets/tasks_screen.dart';
import '../ui/tasks_assignments_guide/widgets/tasks_assignments_guide_screen.dart';
import '../ui/tasks_create/view_models/create_task_screen_viewmodel.dart';
import '../ui/tasks_create/widgets/create_task_screen.dart';
import '../ui/tasks_details/view_models/task_details_screen_view_model.dart';
import '../ui/tasks_details/widgets/task_details_screen.dart';
import '../ui/tasks_details_assignments_edit/view_models/task_assignments_edit_screen_view_model.dart';
import '../ui/tasks_details_assignments_edit/widgets/task_assignments_edit_screen.dart';
import '../ui/tasks_details_edit/view_models/task_details_edit_screen_view_model.dart';
import '../ui/tasks_details_edit/widgets/task_details_edit_screen.dart';
import '../ui/user_profile/view_models/user_profile_view_model.dart';
import '../ui/workspace_create/view_models/create_workspace_screen_viewmodel.dart';
import '../ui/workspace_create/widgets/create_workspace_screen.dart';
import '../ui/workspace_create_initial/view_models/create_workspace_initial_screen_viewmodel.dart';
import '../ui/workspace_create_initial/widgets/create_workspace_initial_screen.dart';
import '../ui/workspace_settings/view_models/workspace_settings_screen_viewmodel.dart';
import '../ui/workspace_settings/widgets/workspace_settings_screen.dart';
import '../ui/workspace_settings_edit/view_models/workspace_settings_edit_screen_view_model.dart';
import '../ui/workspace_settings_edit/widgets/workspace_settings_edit_screen.dart';
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

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>(
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
///           /:id/edit (on root navigator)
///           /:id/assignments/edit (on root navigator)
///           /:id/assignments/guide (on root navigator)
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
    workspaceRepository.hasNoWorkspacesNotifier,
  ]),
  navigatorKey: rootNavigatorKey,
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
      path: '/${Routes.workspacesRelative}',
      builder: (_, _) => const SizedBox.shrink(),
      routes: [
        GoRoute(
          path: Routes.workspaceCreateInitialRelative,
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              transitionDuration: const Duration(milliseconds: 250),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    return SharedAxisTransition(
                      animation: animation,
                      secondaryAnimation: secondaryAnimation,
                      transitionType: SharedAxisTransitionType.scaled,
                      child: child,
                    );
                  },
              child: CreateWorkspaceInitialScreen(
                viewModel: CreateWorkspaceInitialScreenViewModel(
                  workspaceRepository: context.read(),
                  userRepository: context.read(),
                  createWorkspaceUseCase: context.read(),
                ),
              ),
            );
          },
        ),
        GoRoute(
          path: Routes.createRelative,
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              transitionDuration: const Duration(milliseconds: 250),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    return SharedAxisTransition(
                      animation: animation,
                      secondaryAnimation: secondaryAnimation,
                      transitionType: SharedAxisTransitionType.scaled,
                      child: child,
                    );
                  },
              child: CreateWorkspaceScreen(
                viewModel: CreateWorkspaceScreenViewModel(
                  createWorkspaceUseCase: context.read(),
                  joinWorkspaceUseCase: context.read(),
                ),
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
                  // These view models are wrapped in providers, because we want to limit
                  // reinstantianting them on every navigation inside the shell route.
                  providers: [
                    ChangeNotifierProvider(
                      key: ValueKey('bottom_nav_bar_$workspaceId'),
                      create: (notifierContext) =>
                          AppBottomNavigationBarViewModel(
                            workspaceId: workspaceId,
                            userRepository: notifierContext.read(),
                            rbacService: notifierContext.read(),
                          ),
                    ),
                    ChangeNotifierProvider(
                      key: ValueKey('app_drawer_$workspaceId'),
                      create: (notifierContext) => AppDrawerViewModel(
                        workspaceId: workspaceId,
                        workspaceRepository: notifierContext.read(),
                        userRepository: context.read(),
                        refreshTokenUseCase: notifierContext.read(),
                        activeWorkspaceChangeUseCase: notifierContext.read(),
                      ),
                    ),
                    ChangeNotifierProvider(
                      key: ValueKey('user_profile_$workspaceId'),
                      create: (notifierContext) => UserProfileViewModel(
                        workspaceId: workspaceId,
                        userRepository: context.read(),
                        signOutUseCase: context.read(),
                      ),
                    ),
                  ],
                  child: BackButtonHandler(
                    navigationShell: navigationShell,
                    child: AppShellScaffold(
                      workspaceId: workspaceId,
                      navigationShell: navigationShell,
                    ),
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
                          key: ValueKey('tasks_page_$workspaceId'),
                          child: TasksScreen(
                            viewModel: TasksScreenViewModel(
                              workspaceId: workspaceId,
                              userRepository: context.read(),
                              workspaceTaskRepository: context.read(),
                              preferencesRepository: context.read(),
                            ),
                          ),
                        );
                      },
                      routes: [
                        GoRoute(
                          path: Routes.createRelative,
                          parentNavigatorKey: rootNavigatorKey,
                          pageBuilder: (context, state) {
                            final workspaceId =
                                state.pathParameters['workspaceId']!;

                            return CustomTransitionPage(
                              transitionDuration: const Duration(
                                milliseconds: 400,
                              ),
                              transitionsBuilder:
                                  (
                                    context,
                                    animation,
                                    secondaryAnimation,
                                    child,
                                  ) {
                                    return SharedAxisTransition(
                                      animation: animation,
                                      secondaryAnimation: secondaryAnimation,
                                      transitionType:
                                          SharedAxisTransitionType.horizontal,
                                      child: child,
                                    );
                                  },
                              // ChangeNotifierProvider is used because when we navigate (push)
                              // from CreateTaskScreen to the TasksAssignmentsGuideScreen, this whole routes
                              // array of the [Routes.tasksRelative] GoRoute gets rebuilt - pageBuilders
                              // re-instantiate the VM, which then leads to having a quick display
                              // of the CreateTaskScreen (specifically the loader/activity indicator)
                              // and then the TasksAssignmentsGuideScreen is shown.
                              // Basically, when we push to another screen, the current page gets
                              // rebuilt, but it is not deducted from the tree and then again
                              // inserted. This is only when the :workspaceId is the same of course.
                              // If it is different, then the whole tree is rebuilt.
                              child: ChangeNotifierProvider(
                                create: (BuildContext context) =>
                                    CreateTaskScreenViewmodel(
                                      workspaceId: workspaceId,
                                      workspaceTaskRepository: context.read(),
                                      workspaceUserRepository: context.read(),
                                    ),
                                child: Builder(
                                  builder: (BuildContext builderContext) =>
                                      CreateTaskScreen(
                                        viewModel: builderContext.read(),
                                      ),
                                ),
                              ),
                            );
                          },
                        ),
                        GoRoute(
                          path: Routes.guideRelative,
                          parentNavigatorKey: rootNavigatorKey,
                          pageBuilder: (context, state) {
                            return CustomTransitionPage(
                              transitionDuration: const Duration(
                                milliseconds: 400,
                              ),
                              transitionsBuilder:
                                  (
                                    context,
                                    animation,
                                    secondaryAnimation,
                                    child,
                                  ) {
                                    return SharedAxisTransition(
                                      animation: animation,
                                      secondaryAnimation: secondaryAnimation,
                                      transitionType:
                                          SharedAxisTransitionType.horizontal,
                                      child: child,
                                    );
                                  },
                              child: const TasksAssignmentsGuideScreen(),
                            );
                          },
                        ),
                        GoRoute(
                          path: ':taskId',
                          parentNavigatorKey: rootNavigatorKey,
                          pageBuilder: (context, state) {
                            final workspaceId =
                                state.pathParameters['workspaceId']!;
                            final taskId = state.pathParameters['taskId']!;

                            return CustomTransitionPage(
                              transitionDuration: const Duration(
                                milliseconds: 250,
                              ),
                              transitionsBuilder:
                                  (
                                    context,
                                    animation,
                                    secondaryAnimation,
                                    child,
                                  ) {
                                    return SharedAxisTransition(
                                      animation: animation,
                                      secondaryAnimation: secondaryAnimation,
                                      transitionType:
                                          SharedAxisTransitionType.scaled,
                                      child: child,
                                    );
                                  },
                              child: TaskDetailsScreen(
                                viewModel: TaskDetailsScreenViewModel(
                                  workspaceId: workspaceId,
                                  taskId: taskId,
                                  workspaceTaskRepository: context.read(),
                                ),
                              ),
                            );
                          },
                          routes: [
                            GoRoute(
                              path: Routes.editRelative,
                              parentNavigatorKey: rootNavigatorKey,
                              pageBuilder: (context, state) {
                                final workspaceId =
                                    state.pathParameters['workspaceId']!;
                                final taskId = state.pathParameters['taskId']!;

                                return CustomTransitionPage(
                                  transitionDuration: const Duration(
                                    milliseconds: 400,
                                  ),
                                  transitionsBuilder:
                                      (
                                        context,
                                        animation,
                                        secondaryAnimation,
                                        child,
                                      ) {
                                        return SharedAxisTransition(
                                          animation: animation,
                                          secondaryAnimation:
                                              secondaryAnimation,
                                          transitionType:
                                              SharedAxisTransitionType
                                                  .horizontal,
                                          child: child,
                                        );
                                      },
                                  child: TaskDetailsEditScreen(
                                    viewModel: TaskDetailsEditScreenViewModel(
                                      workspaceId: workspaceId,
                                      taskId: taskId,
                                      workspaceTaskRepository: context.read(),
                                    ),
                                  ),
                                );
                              },
                            ),
                            GoRoute(
                              path:
                                  '${Routes.taskDetailsAssignmentsRelative}/${Routes.editRelative}',
                              parentNavigatorKey: rootNavigatorKey,
                              pageBuilder: (context, state) {
                                final workspaceId =
                                    state.pathParameters['workspaceId']!;
                                final taskId = state.pathParameters['taskId']!;

                                return CustomTransitionPage(
                                  transitionDuration: const Duration(
                                    milliseconds: 400,
                                  ),
                                  transitionsBuilder:
                                      (
                                        context,
                                        animation,
                                        secondaryAnimation,
                                        child,
                                      ) {
                                        return SharedAxisTransition(
                                          animation: animation,
                                          secondaryAnimation:
                                              secondaryAnimation,
                                          transitionType:
                                              SharedAxisTransitionType
                                                  .horizontal,
                                          child: child,
                                        );
                                      },
                                  child: TaskAssignmentsEditScreen(
                                    viewModel:
                                        TaskAssignmentsEditScreenViewModel(
                                          workspaceId: workspaceId,
                                          taskId: taskId,
                                          workspaceTaskRepository: context
                                              .read(),
                                          workspaceUserRepository: context
                                              .read(),
                                        ),
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
                StatefulShellBranch(
                  routes: [
                    GoRoute(
                      path: Routes.goalsRelative,
                      pageBuilder: (context, state) {
                        final workspaceId =
                            state.pathParameters['workspaceId']!;
                        return NoTransitionPage(
                          key: ValueKey('goals_page_$workspaceId'),
                          child: GoalsScreen(
                            viewModel: GoalsScreenViewmodel(
                              workspaceId: workspaceId,
                              userRepository: context.read(),
                              workspaceGoalRepository: context.read(),
                              preferencesRepository: context.read(),
                            ),
                          ),
                        );
                      },
                      routes: [
                        GoRoute(
                          path: Routes.createRelative,
                          parentNavigatorKey: rootNavigatorKey,
                          pageBuilder: (context, state) {
                            final workspaceId =
                                state.pathParameters['workspaceId']!;

                            return CustomTransitionPage(
                              transitionDuration: const Duration(
                                milliseconds: 400,
                              ),
                              transitionsBuilder:
                                  (
                                    context,
                                    animation,
                                    secondaryAnimation,
                                    child,
                                  ) {
                                    return SharedAxisTransition(
                                      animation: animation,
                                      secondaryAnimation: secondaryAnimation,
                                      transitionType:
                                          SharedAxisTransitionType.horizontal,
                                      child: child,
                                    );
                                  },
                              // ChangeNotifierProvider is used because when we navigate (push)
                              // from CreateGoalScreen to the GoalsGuideScreen, this whole routes
                              // array of the [Routes.goalsRelative] GoRoute gets rebuilt - pageBuilders
                              // re-instantiate the VM, which then leads to having a quick display
                              // of the CreateGoalScreen (specifically the loader/activity indicator)
                              // and then the GoalsGuideScreen is shown.
                              // Basically, when we push to another screen, the current page gets
                              // rebuilt, but it is not deducted from the tree and then again
                              // inserted. This is only when the :workspaceId is the same of course.
                              // If it is different, then the whole tree is rebuilt.
                              child: ChangeNotifierProvider(
                                create: (BuildContext context) =>
                                    CreateGoalScreenViewmodel(
                                      workspaceId: workspaceId,
                                      workspaceGoalRepository: context.read(),
                                      workspaceUserRepository: context.read(),
                                    ),
                                child: Builder(
                                  builder: (BuildContext builderContext) =>
                                      CreateGoalScreen(
                                        viewModel: builderContext.read(),
                                      ),
                                ),
                              ),
                            );
                          },
                        ),
                        GoRoute(
                          path: Routes.guideRelative,
                          parentNavigatorKey: rootNavigatorKey,
                          pageBuilder: (context, state) {
                            return CustomTransitionPage(
                              transitionDuration: const Duration(
                                milliseconds: 400,
                              ),
                              transitionsBuilder:
                                  (
                                    context,
                                    animation,
                                    secondaryAnimation,
                                    child,
                                  ) {
                                    return SharedAxisTransition(
                                      animation: animation,
                                      secondaryAnimation: secondaryAnimation,
                                      transitionType:
                                          SharedAxisTransitionType.horizontal,
                                      child: child,
                                    );
                                  },
                              child: const GoalsGuideScreen(),
                            );
                          },
                        ),
                        GoRoute(
                          path: ':goalId',
                          parentNavigatorKey: rootNavigatorKey,
                          pageBuilder: (context, state) {
                            final workspaceId =
                                state.pathParameters['workspaceId']!;
                            final goalId = state.pathParameters['goalId']!;

                            return CustomTransitionPage(
                              transitionDuration: const Duration(
                                milliseconds: 250,
                              ),
                              transitionsBuilder:
                                  (
                                    context,
                                    animation,
                                    secondaryAnimation,
                                    child,
                                  ) {
                                    return SharedAxisTransition(
                                      animation: animation,
                                      secondaryAnimation: secondaryAnimation,
                                      transitionType:
                                          SharedAxisTransitionType.scaled,
                                      child: child,
                                    );
                                  },
                              child: GoalDetailsScreen(
                                viewModel: GoalDetailsScreenViewModel(
                                  workspaceId: workspaceId,
                                  goalId: goalId,
                                  workspaceGoalRepository: context.read(),
                                ),
                              ),
                            );
                          },
                          routes: [
                            GoRoute(
                              path: Routes.editRelative,
                              parentNavigatorKey: rootNavigatorKey,
                              pageBuilder: (context, state) {
                                final workspaceId =
                                    state.pathParameters['workspaceId']!;
                                final goalId = state.pathParameters['goalId']!;

                                return CustomTransitionPage(
                                  transitionDuration: const Duration(
                                    milliseconds: 400,
                                  ),
                                  transitionsBuilder:
                                      (
                                        context,
                                        animation,
                                        secondaryAnimation,
                                        child,
                                      ) {
                                        return SharedAxisTransition(
                                          animation: animation,
                                          secondaryAnimation:
                                              secondaryAnimation,
                                          transitionType:
                                              SharedAxisTransitionType
                                                  .horizontal,
                                          child: child,
                                        );
                                      },
                                  child: GoalDetailsEditScreen(
                                    viewModel: GoalDetailsEditScreenViewModel(
                                      workspaceId: workspaceId,
                                      goalId: goalId,
                                      workspaceGoalRepository: context.read(),
                                      workspaceUserRepository: context.read(),
                                    ),
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
                StatefulShellBranch(
                  routes: [
                    GoRoute(
                      path: Routes.leaderboardRelative,
                      pageBuilder: (context, state) {
                        final workspaceId =
                            state.pathParameters['workspaceId']!;

                        return NoTransitionPage(
                          key: ValueKey('leaderboard_page_$workspaceId'),
                          child: LeaderboardScreen(
                            viewModel: LeaderboardScreenViewModel(
                              workspaceId: workspaceId,
                              workspaceLeaderboardRepository: context.read(),
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
              path: Routes.workspaceUsersRelative,
              pageBuilder: (context, state) {
                final workspaceId = state.pathParameters['workspaceId']!;

                return CustomTransitionPage(
                  transitionDuration: const Duration(milliseconds: 250),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                        return SharedAxisTransition(
                          animation: animation,
                          secondaryAnimation: secondaryAnimation,
                          transitionType: SharedAxisTransitionType.scaled,
                          child: child,
                        );
                      },
                  child: WorkspaceUsersManagementScreen(
                    viewModel: WorkspaceUsersManagementScreenViewModel(
                      workspaceId: workspaceId,
                      userRepository: context.read(),
                      workspaceUserRepository: context.read(),
                    ),
                  ),
                );
              },
              routes: [
                GoRoute(
                  path: Routes.createRelative,
                  pageBuilder: (context, state) {
                    final workspaceId = state.pathParameters['workspaceId']!;

                    // We are not using the view model memoization here because we
                    // want the workspace invite repository call to fire everytime we
                    // land on this route, so the repository can check if the cached
                    // workspace invite is expired.
                    return CustomTransitionPage(
                      transitionDuration: const Duration(milliseconds: 400),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                            return SharedAxisTransition(
                              animation: animation,
                              secondaryAnimation: secondaryAnimation,
                              transitionType:
                                  SharedAxisTransitionType.horizontal,
                              child: child,
                            );
                          },
                      child: CreateWorkspaceUserScreen(
                        viewModel: CreateWorkspaceUserScreenViewModel(
                          workspaceId: workspaceId,
                          workspaceRepository: context.read(),
                          workspaceInviteRepository: context.read(),
                          workspaceUserRepository: context.read(),
                          shareWorkspaceInviteLinkUseCase: context.read(),
                        ),
                      ),
                    );
                  },
                ),
                GoRoute(
                  path: Routes.guideRelative,
                  pageBuilder: (context, state) {
                    return CustomTransitionPage(
                      transitionDuration: const Duration(milliseconds: 400),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                            return SharedAxisTransition(
                              animation: animation,
                              secondaryAnimation: secondaryAnimation,
                              transitionType:
                                  SharedAxisTransitionType.horizontal,
                              child: child,
                            );
                          },
                      child: const WorkspaceUsersManagementGuideScreen(),
                    );
                  },
                ),
                GoRoute(
                  path: ':workspaceUserId',
                  pageBuilder: (context, state) {
                    final workspaceId = state.pathParameters['workspaceId']!;
                    final workspaceUserId =
                        state.pathParameters['workspaceUserId']!;

                    // We are not using the view model memoization here because we
                    // want the user details repository call to fire everytime we
                    // land on this route, so we get fresh data for specific workspace
                    // user ID - this is important as Managers can edit workspace user
                    // data, and we are not listening to entire workspace user repository
                    // `users` listenable value on this route, as that would be unnecessary.
                    return CustomTransitionPage(
                      transitionDuration: const Duration(milliseconds: 250),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                            return SharedAxisTransition(
                              animation: animation,
                              secondaryAnimation: secondaryAnimation,
                              transitionType: SharedAxisTransitionType.scaled,
                              child: child,
                            );
                          },
                      child: WorkspaceUserDetailsScreen(
                        viewModel: WorkspaceUserDetailsScreenViewModel(
                          workspaceId: workspaceId,
                          workspaceUserId: workspaceUserId,
                          userRepository: context.read(),
                          workspaceUserRepository: context.read(),
                        ),
                      ),
                    );
                  },
                  routes: [
                    GoRoute(
                      path: Routes.editRelative,
                      pageBuilder: (context, state) {
                        final workspaceId =
                            state.pathParameters['workspaceId']!;
                        final workspaceUserId =
                            state.pathParameters['workspaceUserId']!;

                        return CustomTransitionPage(
                          transitionDuration: const Duration(milliseconds: 400),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                                return SharedAxisTransition(
                                  animation: animation,
                                  secondaryAnimation: secondaryAnimation,
                                  transitionType:
                                      SharedAxisTransitionType.horizontal,
                                  child: child,
                                );
                              },
                          child: WorkspaceUserDetailsEditScreen(
                            viewModel: WorkspaceUserDetailsEditScreenViewModel(
                              workspaceId: workspaceId,
                              workspaceUserId: workspaceUserId,
                              workspaceUserRepository: context.read(),
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
              path: Routes.workspaceSettingsRelative,
              pageBuilder: (context, state) {
                final workspaceId = state.pathParameters['workspaceId']!;

                // We are not using the view model memoization here because we
                // want the workspace details repository call to fire everytime we
                // land on this route, so we get fresh data for specific workspace
                // ID - this is important as Managers can edit workspace data
                // and we are not listening to entire workspace repository
                // `workspaces` listenable value on this route, as that would be unnecessary.
                return CustomTransitionPage(
                  transitionDuration: const Duration(milliseconds: 250),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                        return SharedAxisTransition(
                          animation: animation,
                          secondaryAnimation: secondaryAnimation,
                          transitionType: SharedAxisTransitionType.scaled,
                          child: child,
                        );
                      },
                  child: WorkspaceSettingsScreen(
                    viewModel: WorkspaceSettingsScreenViewModel(
                      workspaceId: workspaceId,
                      workspaceRepository: context.read(),
                    ),
                  ),
                );
              },
              routes: [
                GoRoute(
                  path: Routes.editRelative,
                  pageBuilder: (context, state) {
                    final workspaceId = state.pathParameters['workspaceId']!;

                    return CustomTransitionPage(
                      transitionDuration: const Duration(milliseconds: 400),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                            return SharedAxisTransition(
                              animation: animation,
                              secondaryAnimation: secondaryAnimation,
                              transitionType:
                                  SharedAxisTransitionType.horizontal,
                              child: child,
                            );
                          },
                      child: WorkspaceSettingsEditScreen(
                        viewModel: WorkspaceSettingsEditScreenViewModel(
                          workspaceId: workspaceId,
                          workspaceRepository: context.read(),
                        ),
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
      path: Routes.preferences,
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          transitionDuration: const Duration(milliseconds: 250),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SharedAxisTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              transitionType: SharedAxisTransitionType.scaled,
              child: child,
            );
          },
          child: PreferencesScreen(
            viewModel: PreferencesScreenViewModel(
              preferencesRepository: context.read(),
            ),
          ),
        );
      },
    ),
  ],
);

String? _redirect(BuildContext context, GoRouterState state) {
  // if the user is not part of any workspace anymore (e.g. left all workspaces),
  // we need to redirect the user to workspace initial creation screen
  final hasNoWorkspaces = context
      .read<WorkspaceRepository>()
      .hasNoWorkspacesNotifier
      .value;
  // if the user is not logged in, they need to login
  final loggedIn = context.read<AuthStateRepository>().isAuthenticated;
  final loggingIn = state.matchedLocation == Routes.login;

  if (!loggedIn) {
    return Routes.login;
  }

  // if the user is logged in but still on the login page, send them to the initial route
  if (loggingIn) {
    return Routes.entry;
  }

  // if the user is not part of any workspace, redirect the user to the initial workspace creation page
  if (hasNoWorkspaces != null && hasNoWorkspaces) {
    return Routes.workspaceCreateInitial;
  }

  // no need to redirect
  return null;
}
