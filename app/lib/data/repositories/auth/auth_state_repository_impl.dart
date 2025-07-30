import 'package:logging/logging.dart';

import '../../../utils/command.dart';
import '../../services/local/secure_storage_service.dart';
import 'auth_state_repository.dart';

class AuthStateRepositoryImpl extends AuthStateRepository {
  AuthStateRepositoryImpl({required SecureStorageService secureStorageService})
    : _secureStorageService = secureStorageService;

  final SecureStorageService _secureStorageService;

  // It is initially set to `false` because this will be set
  // on app startup, which happens before gorouter (and hence its
  // redirect function).
  bool _isAuthenticated = false;
  String? _accessToken;
  String? _refreshToken;
  final _log = Logger('AuthStateRepository');

  @override
  bool get isAuthenticated => _isAuthenticated;

  @override
  Future<bool> loadAuthenticatedState() async {
    final result = await _secureStorageService.getAccessToken();
    switch (result) {
      case Ok<String?>():
        // No need to call `notifyListeners` here because this load
        // happens on app startup before the gorouter (and its redirect function).
        _isAuthenticated = result.value != null;
      case Error<String?>():
        _log.severe(
          'Failed to fetch access token from secure storage',
          result.error,
        );
    }

    return _isAuthenticated;
  }

  @override
  Future<(String?, String?)> get tokens async {
    String? accessToken;
    String? refreshToken;

    // Access token is cached
    if (_accessToken != null) {
      accessToken = _accessToken;
    }

    // Access token is not cached, fetch from storage
    final accessTokenResult = await _secureStorageService.getAccessToken();
    switch (accessTokenResult) {
      case Ok<String?>():
        _accessToken = accessTokenResult.value;
        accessToken = accessTokenResult.value;
      case Error<String?>():
        _log.severe(
          'Failed to fetch access token from secure storage',
          accessTokenResult.error,
        );
    }

    // Refresh token is cached
    if (_refreshToken != null) {
      refreshToken = _refreshToken;
    }

    // Refresh token is not cached, fetch from storage
    final refreshTokenResult = await _secureStorageService.getRefreshToken();
    switch (refreshTokenResult) {
      case Ok<String?>():
        _refreshToken = refreshTokenResult.value;
        refreshToken = refreshTokenResult.value;
      case Error<String?>():
        _log.severe(
          'Failed to fetch refresh token from secure storage',
          refreshTokenResult.error,
        );
    }

    return (accessToken, refreshToken);
  }

  @override
  void setAuthenticated(bool isAuthenticated) async {
    _isAuthenticated = isAuthenticated;
    notifyListeners();
  }

  @override
  Future<Result<void>> setTokens((String, String)? tokens) async {
    switch (tokens) {
      case == null:
        final setAccessTokenResult = await _secureStorageService.setAccessToken(
          null,
        );
        final setRefreshTokenResult = await _secureStorageService
            .setRefreshToken(null);

        if (setAccessTokenResult is Error || setRefreshTokenResult is Error) {
          _log.severe(
            'Failed to clear access and/or refresh token from storage',
          );
          return Result.error(Exception());
        }

        _refreshToken = null;
      case != null:
        final (accessToken, refreshToken) = tokens;
        final setAccessTokenResult = await _secureStorageService.setAccessToken(
          accessToken,
        );
        final setRefreshTokenResult = await _secureStorageService
            .setRefreshToken(refreshToken);

        if (setAccessTokenResult is Error || setRefreshTokenResult is Error) {
          _log.severe('Failed to set access and/or refresh token from storage');
          return Result.error(Exception());
        }

        _refreshToken = refreshToken;
    }

    return const Result.ok(null);
  }
}
