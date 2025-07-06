import 'dart:async';

import 'package:dio/dio.dart';

import '../../../../config/api_endpoints.dart';
import '../../../../utils/command.dart';
import '../../../repositories/auth/auth_state_repository.dart';
import '../api_response.dart';
import '../auth/models/request/refresh_token_request.dart';
import '../auth/models/response/refresh_token_response.dart';

class UnauthorizedInterceptor extends Interceptor {
  UnauthorizedInterceptor({
    required AuthStateRepository authStateRepository,
    required Dio mainClient,
    required Dio rawClient,
  }) : _authStateRepository = authStateRepository,
       _rawClient = rawClient,
       _mainClient = mainClient;

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

    if (err.requestOptions.path.contains(ApiEndpoints.refreshToken)) {
      await _authStateRepository.setTokens(null);
      _authStateRepository.setAuthenticated(false);
      return handler.next(err);
    }

    if (_isRefreshing) {
      // Token refresh was already triggered
      if (_refreshTokenCompleter != null) {
        try {
          await _refreshTokenCompleter!.future;
        } on Exception {
          return handler.next(err);
        }
      }

      // Repeat the request which waited for the completer to complete
      return await _repeatRequestAfterTokenRefresh(err, handler);
    }

    // Start the token refresh process
    await _refreshToken(err, handler);

    // _mainClient should now read new accessToken value from storage in RequestHeadersInterceptor

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
      final (_, refreshToken) = await _authStateRepository.tokens;
      final refreshTokenResponse = await _rawClient.post(
        ApiEndpoints.refreshToken,
        data: RefreshTokenRequest(refreshToken),
      );
      final apiResponse = ApiResponse<RefreshTokenResponse>.fromJson(
        refreshTokenResponse.data,
        (json) => RefreshTokenResponse.fromJson(json as Map<String, dynamic>),
      );

      final setAuthResult = await _authStateRepository.setTokens((
        apiResponse.data!.accessToken,
        apiResponse.data!.refreshToken,
      ));

      switch (setAuthResult) {
        case Ok():
          // Complete the completer future
          _refreshTokenCompleter!.complete();
        case Error():
          _refreshTokenCompleter!.completeError(
            'Error saving tokens to the storage',
          );
          return handler.next(originalError);
      }
    } catch (e) {
      _refreshTokenCompleter!.completeError(e);
      await _authStateRepository.setTokens(null);
      _authStateRepository.setAuthenticated(false);
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
    } on DioException catch (e) {
      await _authStateRepository.setTokens(null);
      _authStateRepository.setAuthenticated(false);
      return handler.reject(e);
    }
  }
}
