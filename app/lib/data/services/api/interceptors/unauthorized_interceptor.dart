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
    required Dio client,
  }) : _authStateRepository = authStateRepository,
       _client = client;

  final Dio _client;
  final AuthStateRepository _authStateRepository;

  // Semaphore for token refresh
  bool _isRefreshing = false;
  // Completer which makes other requsts which got 401 response to wait on token refresh finish
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

  // This interceptor can't use refreshToken from AuthRepository (or any repository for that matter)
  // because it depends on AuthApiService which depends on ApiClient, and ApiClient would then
  // depend on AuthRepository - this would result in circular dependency problem.
  Future<void> _refreshToken(
    DioException originalError,
    ErrorInterceptorHandler handler,
  ) async {
    _isRefreshing = true;
    _refreshTokenCompleter = Completer<void>();

    try {
      final (_, refreshToken) = await _authStateRepository.tokens;
      final refreshTokenResponse = await _client.post(
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
      final response = await _client.fetch(originalError.requestOptions);
      return handler.resolve(response);
    } on DioException catch (e) {
      await _authStateRepository.setTokens(null);
      // Log out the user only if the request failed with 401 again
      if (e.response?.statusCode == 401) {
        _authStateRepository.setAuthenticated(false);
      }
      return handler.reject(e);
    }
  }
}
