import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../data/repositories/auth/auth_id_provider_repository.dart';
import '../data/repositories/auth/auth_id_provider_repository_google_impl.dart';
import '../data/repositories/auth/auth_repository.dart';
import '../data/repositories/auth/auth_repository_impl.dart';
import '../data/repositories/auth/auth_state_repository.dart';
import '../data/repositories/auth/auth_state_repository_impl.dart';
import '../data/repositories/client_info/client_info_repository.dart';
import '../data/repositories/client_info/client_info_repository_impl.dart';
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
import '../data/services/api/auth/auth_api_service.dart';
import '../data/services/api/user/user_api_service.dart';
import '../data/services/api/workspace/workspace/workspace_api_service.dart';
import '../data/services/api/workspace/workspace_goal/workspace_goal_api_service.dart';
import '../data/services/api/workspace/workspace_invite/workspace_invite_api_service.dart';
import '../data/services/api/workspace/workspace_leaderboard/workspace_leaderboard_api_service.dart';
import '../data/services/api/workspace/workspace_task/workspace_task_api_service.dart';
import '../data/services/api/workspace/workspace_user/workspace_user_api_service.dart';
import '../data/services/external/google/google_auth_service.dart';
import '../data/services/local/auth_event_bus.dart';
import '../data/services/local/client_info_service.dart';
import '../data/services/local/database_service.dart';
import '../data/services/local/logger_service.dart';
import '../data/services/local/secure_storage_service.dart';
import '../data/services/local/shared_preferences_service.dart';
import '../domain/use_cases/active_workspace_change_use_case.dart';
import '../domain/use_cases/create_workspace_use_case.dart';
import '../domain/use_cases/join_workspace_use_case.dart';
import '../domain/use_cases/purge_data_cache_use_case.dart';
import '../domain/use_cases/refresh_token_use_case.dart';
import '../domain/use_cases/share_workspace_invite_link_use_case.dart';
import '../domain/use_cases/sign_in_use_case.dart';
import '../domain/use_cases/sign_out_use_case.dart';
import '../routing/router.dart';
import '../ui/app_lifecycle_state_listener/view_models/app_lifecycle_state_listener_view_model.dart';
import '../ui/app_startup/view_models/app_startup_view_model.dart';
import '../ui/auth_event_listener/view_models/auth_event_listener_view_model.dart';
import '../ui/core/services/rbac_service.dart';

List<SingleChildWidget> get providers {
  return [
    Provider(create: (context) => LoggerService()),
    Provider(create: (context) => SecureStorageService()),
    Provider(create: (context) => SharedPreferencesService()),
    Provider(create: (context) => GoogleAuthService()),
    Provider(create: (context) => ClientInfoService()),
    Provider(create: (context) => DatabaseService()),
    Provider(create: (context) => AuthEventBus()),
    ChangeNotifierProvider(
      create: (context) =>
          AuthStateRepositoryImpl(
                secureStorageService: context.read(),
                loggerService: context.read(),
              )
              as AuthStateRepository,
    ),
    Provider(
      create: (context) =>
          ClientInfoRepositoryImpl(
                clientInfoService: context.read(),
                loggerService: context.read(),
              )
              as ClientInfoRepository,
    ),
    Provider(
      create: (context) => ApiClient(
        authStateRepository: context.read(),
        clientInfoRepository: context.read(),
        authEventBus: context.read(),
      ),
    ),
    Provider(create: (context) => AuthApiService(apiClient: context.read())),
    Provider(
      create: (context) => AuthGoogleIdProviderRepositoryImpl(
        googleAuthService: context.read(),
        loggerService: context.read(),
      ),
    ),
    Provider(
      create: (context) =>
          AuthRepositoryImpl(
                authApiService: context.read(),
                sharedPreferencesService: context.read(),
                providers: {
                  AuthProvider.google: context
                      .read<AuthGoogleIdProviderRepositoryImpl>(),
                },
                loggerService: context.read(),
              )
              as AuthRepository,
    ),
    Provider(create: (context) => UserApiService(apiClient: context.read())),
    ChangeNotifierProvider(
      create: (context) =>
          UserRepositoryImpl(
                userApiService: context.read(),
                databaseService: context.read(),
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
                databaseService: context.read(),
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
                databaseService: context.read(),
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
                databaseService: context.read(),
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
                databaseService: context.read(),
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
                databaseService: context.read(),
                loggerService: context.read(),
              )
              as WorkspaceLeaderboardRepository,
    ),
    Provider(
      create: (context) => PurgeDataCacheUseCase(
        workspaceUserRepository: context.read(),
        workspaceTaskRepository: context.read(),
        workspaceLeaderboardRepository: context.read(),
        workspaceGoalRepository: context.read(),
        workspaceInviteRepository: context.read(),
      ),
    ),
    Provider(
      create: (context) => ActiveWorkspaceChangeUseCase(
        workspaceRepository: context.read(),
        purgeDataCacheUseCase: context.read(),
        userRepository: context.read(),
      ),
    ),
    Provider(
      create: (context) => JoinWorkspaceUseCase(
        workspaceInviteRepository: context.read(),
        workspaceRepository: context.read(),
        activeWorkspaceChangeUseCase: context.read(),
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
    Provider(
      create: (context) => SignOutUseCase(
        authRepository: context.read(),
        authStateRepository: context.read(),
        workspaceRepository: context.read(),
        userRepository: context.read(),
        purgeDataCacheUseCase: context.read(),
        loggerService: context.read(),
      ),
    ),
    Provider<GoRouter>(
      create: (context) => router(
        authStateRepository: context.read(),
        workspaceRepository: context.read(),
      ),
    ),
    Provider(
      create: (context) => AppStartupViewModel(
        authStateRepository: context.read(),
        clientInfoRepository: context.read(),
      ),
    ),
    ChangeNotifierProvider(
      create: (context) => AuthEventListenerViewmodel(
        workspaceRepository: context.read(),
        userRepository: context.read(),
        activeWorkspaceChangeUseCase: context.read(),
        signOutUseCase: context.read(),
      ),
    ),
    Provider(
      create: (context) => AppLifecycleStateListenerViewModel(
        userRepository: context.read(),
        workspaceRepository: context.read(),
        authEventBus: context.read(),
      ),
    ),
  ];
}
