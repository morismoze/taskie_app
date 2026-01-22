import '../../../utils/command.dart';
import '../../services/local/logger_service.dart';
import '../../services/local/secure_storage_service.dart';
import 'auth_state_repository.dart';

class AuthStateRepositoryImpl extends AuthStateRepository {
  AuthStateRepositoryImpl({
    required SecureStorageService secureStorageService,
    required LoggerService loggerService,
  }) : _secureStorageService = secureStorageService,
       _loggerService = loggerService;

  final SecureStorageService _secureStorageService;
  final LoggerService _loggerService;

  // It is initially set to `false` because this will be set
  // on app startup, which happens before gorouter (and hence its
  // redirect function).
  bool _isAuthenticated = false;
  String? _accessToken;
  String? _refreshToken;

  @override
  bool get isAuthenticated => _isAuthenticated;

  @override
  Future<(String?, String?)> get tokens async {
    // Access token is cached
    if (_accessToken == null) {
      // Access token is not cached, fetch from storage
      final accessTokenResult = await _secureStorageService.getAccessToken();
      switch (accessTokenResult) {
        case Ok<String?>():
          _accessToken = accessTokenResult.value;
        case Error<String?>():
          _loggerService.log(
            LogLevel.warn,
            'secureStorage.getAccessToken failed',
            error: accessTokenResult.error,
            stackTrace: accessTokenResult.stackTrace,
          );
      }
    }

    // Refresh token is cached
    if (_refreshToken == null) {
      // Refresh token is not cached, fetch from storage
      final refreshTokenResult = await _secureStorageService.getRefreshToken();
      switch (refreshTokenResult) {
        case Ok<String?>():
          _refreshToken = refreshTokenResult.value;
        case Error<String?>():
          _loggerService.log(
            LogLevel.warn,
            'secureStorage.getRefreshToken failed',
            error: refreshTokenResult.error,
            stackTrace: refreshTokenResult.stackTrace,
          );
      }
    }

    return (_accessToken, _refreshToken);
  }

  @override
  Future<bool> loadAuthenticatedState() async {
    final result = await _secureStorageService.getAccessToken();

    switch (result) {
      case Ok<String?>():
        // No need to call `notifyListeners` here because this load
        // happens on app startup before the gorouter (and its redirect function).
        _isAuthenticated = result.value != null;
      case Error<String?>():
        _loggerService.log(
          LogLevel.warn,
          'secureStorage.getAccessToken failed',
          error: result.error,
          stackTrace: result.stackTrace,
        );
    }

    return _isAuthenticated;
  }

  @override
  void setAuthenticated(bool isAuthenticated) {
    _isAuthenticated = isAuthenticated;
    notifyListeners();
  }

  @override
  Future<Result<void>> setTokens((String, String)? tokens) async {
    if (tokens == null) {
      // Clear tokens
      final result = await _secureStorageService.clearTokens();

      switch (result) {
        case Ok():
          _accessToken = null;
          _refreshToken = null;
          return const Result.ok(null);
        case Error():
          _loggerService.log(
            LogLevel.error,
            'secureStorage.clearTokens failed',
            error: result.error,
            stackTrace: result.stackTrace,
          );
          return result;
      }
    }

    // Set tokens
    final (accessToken, refreshToken) = tokens;
    final setAccessTokenResult = await _secureStorageService.setAccessToken(
      accessToken,
    );
    final setRefreshTokenResult = await _secureStorageService.setRefreshToken(
      refreshToken,
    );

    if (setAccessTokenResult is Error || setRefreshTokenResult is Error) {
      final error = setAccessTokenResult is Error
          ? setAccessTokenResult.error
          : (setRefreshTokenResult as Error).error;
      final stackTrace = setAccessTokenResult is Error
          ? setAccessTokenResult.stackTrace
          : (setRefreshTokenResult as Error).stackTrace;

      _loggerService.log(
        LogLevel.error,
        'secureStorage.setTokens failed',
        error: error,
        stackTrace: stackTrace,
      );

      // Best-effort rollback to keep the storage consistent
      final rollback = await _secureStorageService.clearTokens();
      if (rollback is Error) {
        _loggerService.log(
          LogLevel.error,
          'secureStorage.clearTokens rollback failed',
          error: rollback.error,
          stackTrace: rollback.stackTrace,
        );
      }

      _accessToken = null;
      _refreshToken = null;

      return Result.error(Exception('secureStorage.setTokens failed'));
    }

    _accessToken = accessToken;
    _refreshToken = refreshToken;

    return const Result.ok(null);
  }
}
