import 'dart:async';

import 'package:dio/dio.dart';

import '../../../../config/api_endpoints.dart';
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

  // This client uses request interceptor which sets the Authorization
  // Bearer from access token read from secure storage
  final Dio _mainClient;
  // This client is the same as mainClient (basic options wise), but
  // doesn't have any interceptor. It is used for token refresh request
  // because backend expects the Authorization Bearer header to be set
  // to the refresh token (not access token) and as we have that request
  // interceptor on main client (which sets the Authorization Bearer header
  // to access token), it can't be used.
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

    // This interceptor will never trigger for 401 on /auth/refresh because
    // we used rawClient for that request, and that client doesn't have any
    // interceptors, meaning it doesn't use this UnauthorizedInterceptor, so there
    // is not chance of loop 401 problem.

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
          _logoutUser();
          return handler.next(err);
        }
      }

      // Repeat the request which waited for the completer to complete
      return await _repeatRequestAfterTokenRefresh(err, handler);
    }

    // Start the token refresh process
    await _refreshToken(err, handler);

    // _mainClient should now in RequestHeadersInterceptor read new accessToken value from storage

    // Repeat the original request which first fired 401 interceptor
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
        ApiEndpoints.refreshToken,
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
        _refreshTokenCompleter!.completeError(
          'Error saving tokens to the storage:',
        );
        await _logoutUser();
        return handler.next(originalError);
      }

      // Complete the completer future
      _refreshTokenCompleter!.complete();
    } catch (e) {
      _refreshTokenCompleter!.completeError(e);
      await _logoutUser();
      return handler.next(originalError);
    } finally {
      _isRefreshing = false;
      _refreshTokenCompleter = null;
    }
  }

  Future<void> _repeatRequestAfterTokenRefresh(
    DioException originalError,
    ErrorInterceptorHandler handler,
  ) async {
    try {
      final response = await _mainClient.fetch(originalError.requestOptions);
      return handler.resolve(response);
    } on Exception {
      // do something here
    }
  }

  Future<void> _logoutUser() async {
    try {
      await _mainClient.delete(ApiEndpoints.logout);
    } finally {
      _authStateRepository.setAuthenticated(SetAuthStateArgumentsFalse());
    }
  }
}
