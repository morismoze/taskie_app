import '../../data/repositories/auth/auth_repository.dart';
import '../../data/repositories/auth/auth_state_repository.dart';
import '../../data/repositories/user/user_repository.dart';
import '../../data/repositories/workspace/workspace/workspace_repository.dart';
import '../../data/services/local/logger_service.dart';
import '../../utils/command.dart';
import 'purge_data_cache_use_case.dart';

class SignOutUseCase {
  SignOutUseCase({
    required AuthRepository authRepository,
    required AuthStateRepository authStateRepository,
    required WorkspaceRepository workspaceRepository,
    required UserRepository userRepository,
    required PurgeDataCacheUseCase purgeDataCacheUseCase,
    required LoggerService loggerService,
  }) : _authRepository = authRepository,
       _authStateRepository = authStateRepository,
       _workspaceRepository = workspaceRepository,
       _userRepository = userRepository,
       _purgeDataCacheUseCase = purgeDataCacheUseCase,
       _loggerService = loggerService;

  final AuthRepository _authRepository;
  final AuthStateRepository _authStateRepository;
  final WorkspaceRepository _workspaceRepository;
  final UserRepository _userRepository;
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
    // Firstly set authenticated flag to false and then
    // do all other logic
    _authStateRepository.setAuthenticated(false);

    final result = await _authRepository.signOut();

    await _performLocalCleanup();

    switch (result) {
      case Ok():
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

  /// Used on failed token refresh
  Future<void> forceLocalSignOut() async {
    // Not calling API since we don't have valid
    // token anymore because token refresh failed

    // Firstly set authenticated flag to false and then
    // do all other logic
    _authStateRepository.setAuthenticated(false);
    await _performLocalCleanup();
    await _authRepository.signOutFromActiveProvider();
  }

  Future<void> _performLocalCleanup() async {
    await _purgeDataCacheUseCase.purgeDataCache();
    // This needs to be done only in the case of a
    // sign out - hence why it is not in the
    // purgeDataCache method.
    await _workspaceRepository.purgeWorkspacesCache();
    await _userRepository.purgeUserCache();
    await _authStateRepository.setTokens(null);
    _loggerService.clearState();
  }
}
