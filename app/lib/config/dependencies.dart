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
import '../data/repositories/workspace/workspace_repository.dart';
import '../data/repositories/workspace/workspace_repository_impl.dart';
import '../data/services/api/api_client.dart';
import '../data/services/api/auth/auth_api_service.dart';
import '../data/services/api/user/user_api_service.dart';
import '../data/services/api/workspace/workspace_api_service.dart';
import '../data/services/external/google/google_auth_service.dart';
import '../data/services/local/secure_storage_service.dart';
import '../data/services/local/shared_preferences_service.dart';
import '../domain/use_cases/create_workspace_use_case.dart';
import '../domain/use_cases/refresh_token_use_case.dart';
import '../domain/use_cases/sign_in_use_case.dart';

List<SingleChildWidget> get providers {
  return [
    Provider(create: (context) => SecureStorageService()),
    Provider(create: (context) => SharedPreferencesService()),
    Provider(create: (context) => GoogleAuthService()),
    ChangeNotifierProvider(
      create: (context) =>
          AuthStateRepositoryImpl(secureStorageService: context.read())
              as AuthStateRepository,
    ),
    Provider(
      create: (context) => ApiClient(authStateRepository: context.read()),
    ),
    Provider(create: (context) => AuthApiService(apiClient: context.read())),
    Provider(
      create: (context) =>
          AuthRepositoryImpl(
                authApiService: context.read(),
                googleAuthService: context.read(),
              )
              as AuthRepository,
    ),
    Provider(create: (context) => UserApiService(apiClient: context.read())),
    Provider(
      create: (context) =>
          UserRepositoryImpl(userApiService: context.read()) as UserRepository,
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
              )
              as WorkspaceRepository,
    ),
    Provider(
      create: (context) => PreferencesRepositoryImpl() as PreferencesRepository,
    ),
    Provider(
      create: (context) => RefreshTokenUseCase(
        authRepository: context.read(),
        authStateRepository: context.read(),
      ),
    ),
    Provider(
      create: (context) => CreateWorkspaceUseCase(
        refreshTokenUseCase: context.read(),
        userRepository: context.read(),
        workspaceRepository: context.read(),
      ),
    ),
  ];
}
