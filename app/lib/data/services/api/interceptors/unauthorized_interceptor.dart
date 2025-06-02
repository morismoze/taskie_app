import 'dart:async';

import 'package:dio/dio.dart';

import '../../../../utils/command.dart';
import '../../../repositories/auth/auth_state_repository.dart';
import '../../local/secure_storage_service.dart';
import '../auth/models/response/token_refresh_response.dart';

class UnauthorizedInterceptor extends Interceptor {
  UnauthorizedInterceptor({
    required AuthStateRepository authStateRepository,
    required Dio mainClient,
    required Dio rawClient,
    required SecureStorageService secureStorageService,
  }) : _authStateRepository = authStateRepository,
       _rawClient = rawClient,
       _mainClient = mainClient,
       _secureStorageService = secureStorageService;

  final Dio _mainClient;
  final Dio _rawClient;
  final SecureStorageService _secureStorageService;
  final AuthStateRepository _authStateRepository;

  // Semaphore for token refresh
  bool _isRefreshing = false;
  // Completer which waits on token refresh finish
  Completer<void>? _refreshTokenCompleter;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }

    // if the refresh token is invalid, logout user
    if (err.requestOptions.path.contains('/auth/refresh')) {
      await _logoutUser();
      return handler.next(err);
    }

    if (err.requestOptions.path.contains('/auth/logout')) {
      _authStateRepository.setAuthenticated(SetAuthStateArgumentsFalse());
      return handler.next(err);
    }

    if (_isRefreshing) {
      // Token refresh was already triggered
      if (_refreshTokenCompleter != null) {
        try {
          await _refreshTokenCompleter!.future;
        } on Exception {
          _refreshTokenCompleter = null;
          _logoutUser();
          return handler.next(err);
        }
      }

      // Repeat request
      await _repeatRequestAfterTokenRefresh(err, handler);
      _refreshTokenCompleter = null;

      return;
    }

    // Start the token refresh process
    await _refreshToken(err, handler);

    // _mainClient should now in RequestHeadersInterceptor read new accessToken value from storage

    // Complete the completer future
    _refreshTokenCompleter!.complete();

    // Repeat request
    return await _repeatRequestAfterTokenRefresh(err, handler);
  }

  Future<void> _refreshToken(
    DioException originalError,
    ErrorInterceptorHandler handler,
  ) async {
    _isRefreshing = true;
    _refreshTokenCompleter = Completer<void>();

    try {
      final refreshTokenResult = await _secureStorageService.getRefreshToken();

      if (refreshTokenResult is Error) {
        await _logoutUser();
        return handler.next(originalError);
      }

      final refreshToken = (refreshTokenResult as Ok<String>).value;
      final refreshTokenResponse = await _rawClient.post(
        '/auth/refresh',
        options: Options(headers: {'Authorization': refreshToken}),
      );
      final data = TokenRefreshResponse.fromJson(refreshTokenResponse.data);

      final setAccessTokenResult = await _secureStorageService.setAccessToken(
        data.accessToken,
      );
      final setRefreshTokenResult = await _secureStorageService.setRefreshToken(
        data.refreshToken,
      );

      if (setAccessTokenResult is Error || setRefreshTokenResult is Error) {
        await _logoutUser();
        return handler.next(originalError);
      }
    } catch (e) {
      _refreshTokenCompleter!.completeError(e);
      await _logoutUser();
      return handler.next(originalError);
    } finally {
      _isRefreshing = false;
    }
  }

  Future<void> _repeatRequestAfterTokenRefresh(
    DioException originalError,
    ErrorInterceptorHandler handler,
  ) async {
    final response = await _mainClient.fetch(originalError.requestOptions);
    return handler.resolve(response);
  }

  Future<void> _logoutUser() async {
    try {
      await _mainClient.delete('/auth/logout');
    } finally {
      _authStateRepository.setAuthenticated(SetAuthStateArgumentsFalse());
    }
  }
}
