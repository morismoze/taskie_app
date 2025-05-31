import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../../utils/command.dart';
import '../local/secure_storage_service.dart';
import 'auth/auth_api_service.dart';
import 'auth/models/response/token_refresh_response.dart';

class ApiClient {
  ApiClient({
    required AuthApiService authApiService,
    required SecureStorageService secureStorageService,
  }) : _authApiService = authApiService,
       _secureStorageService = secureStorageService,
       _client = Dio(
         BaseOptions(
           baseUrl: "https://localhost:5000",
           headers: {'Content-Type': 'application/json'},
         ),
       ) {
    _client.interceptors.addAll([
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final accessTokenResult = await _secureStorageService
              .getAccessToken();
          switch (accessTokenResult) {
            case Ok<String>():
              options.headers['Authorization'] =
                  'Bearer ${accessTokenResult.value}';
              break;
            default:
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (DioException error, handler) async {
          if (error.response?.statusCode == HttpStatus.unauthorized) {
            return await _handle401Error(error, handler);
          }
          return handler.next(error);
        },
      ),
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        enabled: kReleaseMode == false,
      ),
    ]);
  }

  final Dio _client;
  final AuthApiService _authApiService;
  final SecureStorageService _secureStorageService;

  // Semaphore for token refresh
  bool _isRefreshing = false;
  // Completer which waits on token refresh finish
  Completer<void>? _refreshTokenCompleter;

  Dio get client => _client;

  Future<void> _handle401Error(
    DioException error,
    ErrorInterceptorHandler handler,
  ) async {
    if (_isRefreshing) {
      if (_refreshTokenCompleter != null) {
        await _refreshTokenCompleter!.future;
      }
      return handler.next(error);
    }

    _isRefreshing = true;
    _refreshTokenCompleter = Completer<void>();

    try {
      final refreshTokenResult = await _authApiService.refreshToken();

      switch (refreshTokenResult) {
        case Ok<TokenRefreshResponse>():
          _refreshTokenCompleter!.complete();
          // Repeat original request
          return handler.next(error);
        case Error<TokenRefreshResponse>():
          _refreshTokenCompleter!.complete();
        // set with authrepo isauthenticated to false
      }
    } catch (e) {
      _refreshTokenCompleter!.completeError(e);
      rethrow;
    } finally {
      _isRefreshing = false;
      _refreshTokenCompleter = null;
    }
  }
}
