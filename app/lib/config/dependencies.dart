import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../data/repositories/auth/auth_repository.dart';
import '../data/repositories/auth/auth_repository_impl.dart';
import '../data/repositories/auth/auth_state_repository.dart';
import '../data/repositories/auth/auth_state_repository_impl.dart';
import '../data/repositories/preferences/preferences_repository.dart';
import '../data/repositories/preferences/preferences_repository_impl.dart';
import '../data/repositories/user/user_repository.dart';
import '../data/repositories/user/user_repository_impl.dart';
import '../data/repositories/workspace/leaderboard/workspace_leaderboard_repository.dart';
import '../data/repositories/workspace/leaderboard/workspace_leaderboard_repository_impl.dart';
import '../data/repositories/workspace/workspace/workspace_repository.dart';
import '../data/repositories/workspace/workspace/workspace_repository_impl.dart';
import '../data/repositories/workspace/workspace_goal/workspace_goal_repository.dart';
import '../data/repositories/workspace/workspace_goal/workspace_goal_repository_impl.dart';
import '../data/repositories/workspace/workspace_invite/workspace_invite_repository.dart';
import '../data/repositories/workspace/workspace_invite/workspace_invite_repository_impl.dart';
import '../data/repositories/workspace/workspace_task/workspace_task_repository.dart';
import '../data/repositories/workspace/workspace_task/workspace_task_repository_impl.dart';
import '../data/repositories/workspace/workspace_user/workspace_user_repository.dart';
import '../data/repositories/workspace/workspace_user/workspace_user_repository_impl.dart';
import '../data/services/api/api_client.dart';
import '../data/services/api/api_deeplink_client.dart';
import '../data/services/api/auth/auth_api_service.dart';
import '../data/services/api/user/user_api_service.dart';
import '../data/services/api/workspace/workspace/workspace_api_service.dart';
import '../data/services/api/workspace/workspace_goal/workspace_goal_api_service.dart';
import '../data/services/api/workspace/workspace_invite/workspace_invite_api_service.dart';
import '../data/services/api/workspace/workspace_leaderboard/workspace_leaderboard_api_service.dart';
import '../data/services/api/workspace/workspace_task/workspace_task_api_service.dart';
import '../data/services/api/workspace/workspace_user/workspace_user_api_service.dart';
import '../data/services/external/google/google_auth_service.dart';
import '../data/services/local/logger.dart';
import '../data/services/local/secure_storage_service.dart';
import '../data/services/local/shared_preferences_service.dart';
import '../domain/use_cases/active_workspace_change_use_case.dart';
import '../domain/use_cases/create_workspace_use_case.dart';
import '../domain/use_cases/join_workspace_use_case.dart';
import '../domain/use_cases/refresh_token_use_case.dart';
import '../domain/use_cases/share_workspace_invite_link_use_case.dart';
import '../domain/use_cases/sign_in_use_case.dart';
import '../ui/core/services/rbac_service.dart';

List<SingleChildWidget> get providers {
  return [
    Provider(create: (context) => LoggerService()),
    Provider(create: (context) => SecureStorageService()),
    Provider(create: (context) => SharedPreferencesService()),
    Provider(create: (context) => GoogleAuthService()),
    ChangeNotifierProvider(
      create: (context) =>
          AuthStateRepositoryImpl(
                secureStorageService: context.read(),
                loggerService: context.read(),
              )
              as AuthStateRepository,
    ),
    Provider(
      create: (context) => ApiClient(authStateRepository: context.read()),
    ),
    Provider(
      create: (context) =>
          ApiDeepLinkClient(authStateRepository: context.read()),
    ),
    Provider(create: (context) => AuthApiService(apiClient: context.read())),
    Provider(
      create: (context) =>
          AuthRepositoryImpl(
                authApiService: context.read(),
                googleAuthService: context.read(),
                loggerService: context.read(),
              )
              as AuthRepository,
    ),
    Provider(create: (context) => UserApiService(apiClient: context.read())),
    ChangeNotifierProvider(
      create: (context) =>
          UserRepositoryImpl(
                userApiService: context.read(),
                loggerService: context.read(),
              )
              as UserRepository,
    ),
    Provider(
      create: (context) => SignInUseCase(
        authRepository: context.read(),
        authStateRepository: context.read(),
        userRepository: context.read(),
      ),
    ),
    Provider(
      create: (context) => WorkspaceApiService(apiClient: context.read()),
    ),
    ChangeNotifierProvider(
      create: (context) =>
          WorkspaceRepositoryImpl(
                workspaceApiService: context.read(),
                sharedPreferencesService: context.read(),
                loggerService: context.read(),
              )
              as WorkspaceRepository,
    ),
    Provider(
      create: (context) => WorkspaceTaskApiService(apiClient: context.read()),
    ),
    ChangeNotifierProvider(
      create: (context) =>
          WorkspaceTaskRepositoryImpl(
                workspaceTaskApiService: context.read(),
                loggerService: context.read(),
              )
              as WorkspaceTaskRepository,
    ),
    Provider(
      create: (context) => WorkspaceGoalApiService(apiClient: context.read()),
    ),
    ChangeNotifierProvider(
      create: (context) =>
          WorkspaceGoalRepositoryImpl(
                workspaceGoalApiService: context.read(),
                loggerService: context.read(),
              )
              as WorkspaceGoalRepository,
    ),
    Provider(
      create: (context) => WorkspaceUserApiService(apiClient: context.read()),
    ),
    ChangeNotifierProvider(
      create: (context) =>
          WorkspaceUserRepositoryImpl(
                workspaceUserApiService: context.read(),
                loggerService: context.read(),
              )
              as WorkspaceUserRepository,
    ),
    Provider(
      create: (context) => WorkspaceInviteApiService(apiClient: context.read()),
    ),
    Provider(
      create: (context) =>
          WorkspaceInviteRepositoryImpl(
                workspaceInviteApiService: context.read(),
                loggerService: context.read(),
              )
              as WorkspaceInviteRepository,
    ),
    ChangeNotifierProvider(
      create: (context) =>
          PreferencesRepositoryImpl(
                sharedPreferencesService: context.read(),
                loggerService: context.read(),
              )
              as PreferencesRepository,
    ),
    Provider(
      create: (context) => RefreshTokenUseCase(
        authRepository: context.read(),
        authStateRepository: context.read(),
      ),
    ),
    Provider(
      create: (context) =>
          WorkspaceLeaderboardApiService(apiClient: context.read()),
    ),
    ChangeNotifierProvider(
      create: (context) =>
          WorkspaceLeaderboardRepositoryImpl(
                workspaceLeaderboardApiService: context.read(),
                loggerService: context.read(),
              )
              as WorkspaceLeaderboardRepository,
    ),
    Provider(
      create: (context) => ActiveWorkspaceChangeUseCase(
        workspaceRepository: context.read(),
        workspaceUserRepository: context.read(),
        workspaceTaskRepository: context.read(),
        workspaceLeaderboardRepository: context.read(),
        workspaceGoalRepository: context.read(),
        userRepository: context.read(),
      ),
    ),
    Provider(
      create: (context) => JoinWorkspaceUseCase(
        workspaceInviteRepository: context.read(),
        workspaceRepository: context.read(),
        userRepository: context.read(),
        refreshTokenUseCase: context.read(),
      ),
    ),
    Provider(
      create: (context) => CreateWorkspaceUseCase(
        workspaceRepository: context.read(),
        refreshTokenUseCase: context.read(),
        activeWorkspaceChangeUseCase: context.read(),
      ),
    ),
    ChangeNotifierProvider(
      create: (context) => RbacService(userRepository: context.read()),
    ),
    Provider(lazy: true, create: (_) => ShareWorkspaceInviteLinkUseCase()),
  ];
}
