import '../../data/repositories/auth/auth_repository.dart';
import '../../data/repositories/auth/auth_state_repository.dart';
import '../../data/repositories/workspace/workspace/workspace_repository.dart';
import '../../data/services/local/logger_service.dart';
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
  /// 5. clear LoggerService state
  ///
  /// This use case is not used in the UnauthorizedInterceptor because
  /// we would have circular dependencies problem: ApiClient
  /// depends on the SignOutUseCase, which depends on the AuthRepository
  /// which depends on the AuthApiService which then depends on the ApiClient.
  Future<Result<void>> signOut() async {
    final result = await _authRepository.signOut();

    switch (result) {
      case Ok():
        _performLocalCleanup();
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

  Future<void> forceLocalSignOut() async {
    // Not calling API since we don't have valid
    // token anymore because token refresh failed
    await _authRepository.signOutFromActiveProvider();
    await _performLocalCleanup();
  }

  Future<void> _performLocalCleanup() async {
    await _purgeDataCacheUseCase.purgeDataCache();
    // This needs to be done only in the case of a
    // sign out - hence why it is not in the
    // purgeDataCache method.
    await _workspaceRepository.purgeWorkspacesCache();
    _authStateRepository.setAuthenticated(false);
    await _authStateRepository.setTokens(null);
    _loggerService.clearState();
  }
}
