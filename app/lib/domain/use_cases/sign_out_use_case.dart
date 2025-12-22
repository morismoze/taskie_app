import '../../data/repositories/auth/auth_repository.dart';
import '../../data/repositories/auth/auth_state_repository.dart';
import '../../data/repositories/workspace/workspace/workspace_repository.dart';
import '../../data/services/local/logger.dart';
import '../../utils/command.dart';
import 'purge_data_cache_use_case.dart';

class SignOutUseCase {
  SignOutUseCase({
    required AuthRepository authRepository,
    required AuthStateRepository authStateRepository,
    required WorkspaceRepository workspaceRepository,
    required PurgeDataCacheUseCase purgeDataCacheUseCase,
    required LoggerService loggerService,
  }) : _authRepository = authRepository,
       _authStateRepository = authStateRepository,
       _workspaceRepository = workspaceRepository,
       _purgeDataCacheUseCase = purgeDataCacheUseCase,
       _loggerService = loggerService;

  final AuthRepository _authRepository;
  final AuthStateRepository _authStateRepository;
  final WorkspaceRepository _workspaceRepository;
  final PurgeDataCacheUseCase _purgeDataCacheUseCase;
  final LoggerService _loggerService;

  /// On sign out we need to do couple of things:
  /// 1. trigger sign out from [AuthRepository]
  /// 2. purge data cache
  /// 3. make active workspace null
  /// 4. set authenticated state in [AuthStateRepository]
  ///
  /// This use case is not used in the UnauthorizedInterceptor because
  /// we would have circular dependencies problem: ApiClient
  /// depends on the SignOutUseCase, which depends on the AuthRepository
  /// which depends on the AuthApiService which then depends on the ApiClient.
  Future<Result<void>> signOut() async {
    final result = await _authRepository.signOut();

    switch (result) {
      case Ok():
        final resultSetActiveWorkspace = await _workspaceRepository
            .setActiveWorkspaceId(null);

        if (resultSetActiveWorkspace is Error) {
          // This is important and an error needs to be returned in this
          // case because if a user signs out, and then signs in with another
          // email/provider, active workspace ID will still be from the
          // previous user, which is fatal.
          _loggerService.log(
            LogLevel.error,
            'workspaceRepository.setActiveWorkspaceId failed',
            error: resultSetActiveWorkspace.error,
            stackTrace: resultSetActiveWorkspace.stackTrace,
          );
          return Result.error(
            resultSetActiveWorkspace.error,
            resultSetActiveWorkspace.stackTrace,
          );
        }

        _purgeDataCacheUseCase.purgeDataCache();
        // This needs to be done only in the case of a
        // sign out - hence why it is not in the
        // purgeWorkspacesCache method.
        _workspaceRepository.purgeWorkspacesCache();
        _authStateRepository.setAuthenticated(false);
        _authStateRepository.setTokens(null);
        return const Result.ok(null);
      case Error():
        _loggerService.log(
          LogLevel.warn,
          'authRepository.signOut failed',
          error: result.error,
          stackTrace: result.stackTrace,
        );
        return Result.error(result.error, result.stackTrace);
    }
  }
}
