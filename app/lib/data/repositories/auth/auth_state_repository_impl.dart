import 'package:logging/logging.dart';

import '../../../utils/command.dart';
import '../../services/local/secure_storage_service.dart';
import 'auth_state_repository.dart';

/// This repository is designed to use only by [AuthRepository] and [ApiClient] classes
class AuthStateRepositoryImpl extends AuthStateRepository {
  AuthStateRepositoryImpl({required SecureStorageService secureStorageService})
    : _secureStorageService = secureStorageService;

  final SecureStorageService _secureStorageService;

  bool? _isAuthenticated = false;
  final _log = Logger('AuthStateRepository');

  @override
  Future<bool> get isAuthenticated async {
    // Status is cached
    if (_isAuthenticated != null) {
      return _isAuthenticated!;
    }

    // Status is not cached, fetch from storage
    final result = await _secureStorageService.getAccessToken();
    switch (result) {
      case Ok<String?>():
        _isAuthenticated = result.value != null;
      case Error<String?>():
        _log.severe(
          'Failed to fetch access token from secure storage',
          result.error,
        );
    }

    return _isAuthenticated ?? false;
  }

  @override
  void setAuthenticated(SetAuthStateArguments args) async {
    switch (args) {
      case SetAuthStateArgumentsFalse():
        if (_isAuthenticated != false) {
          _isAuthenticated = false;
          notifyListeners();

          final setAccessTokenResult = await _secureStorageService
              .setAccessToken(null);
          final setRefreshTokenResult = await _secureStorageService
              .setRefreshToken(null);

          if (setAccessTokenResult is Error || setRefreshTokenResult is Error) {
            _log.severe(
              'Failed to clear access and/or refresh token from storage',
            );
          }
        }
      case SetAuthStateArgumentsTrue():
        if (_isAuthenticated != true) {
          _isAuthenticated = true;
          notifyListeners();

          final setAccessTokenResult = await _secureStorageService
              .setAccessToken(args.accessToken);
          final setRefreshTokenResult = await _secureStorageService
              .setRefreshToken(args.refreshToken);

          if (setAccessTokenResult is Error || setRefreshTokenResult is Error) {
            _log.severe(
              'Failed to set access and/or refresh token from storage',
            );
          }
        }
    }
  }
}
