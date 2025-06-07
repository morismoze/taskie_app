import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../data/repositories/auth/auth_repository.dart';
import '../data/repositories/auth/auth_repository_impl.dart';
import '../data/repositories/auth/auth_state_repository.dart';
import '../data/repositories/auth/auth_state_repository_impl.dart';
import '../data/repositories/workspace/workspace_repository.dart';
import '../data/repositories/workspace/workspace_repository_impl.dart';
import '../data/services/api/api_client.dart';
import '../data/services/api/auth/auth_api_service.dart';
import '../data/services/api/workspace/workspace_api_service.dart';
import '../data/services/external/google/google_auth_service.dart';
import '../data/services/local/secure_storage_service.dart';

List<SingleChildWidget> get providers {
  return [
    Provider(create: (context) => SecureStorageService()),
    Provider(create: (context) => GoogleAuthService()),
    ChangeNotifierProvider(
      create: (context) =>
          AuthStateRepositoryImpl(secureStorageService: context.read())
              as AuthStateRepository,
    ),
    Provider(
      create: (context) => ApiClient(
        authStateRepository: context.read(),
        secureStorageService: context.read(),
      ),
    ),
    Provider(create: (context) => AuthApiService(apiClient: context.read())),
    Provider(
      create: (context) =>
          AuthRepositoryImpl(
                authStateRepository: context.read(),
                authApiService: context.read(),
                googleAuthService: context.read(),
              )
              as AuthRepository,
    ),
    Provider(
      create: (context) => WorkspaceApiService(apiClient: context.read()),
    ),
    Provider(
      create: (context) =>
          WorkspaceRepositoryImpl(workspaceApiService: context.read())
              as WorkspaceRepository,
    ),
  ];
}
