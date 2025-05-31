// lib/data/services/api/dio_client.dart
import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

import '../../../utils/command.dart';
import '../local/secure_storage_service.dart';
import 'models/auth/auth_api_service.dart';

class DioClient {
  DioClient(this._authApiService, this._secureStorageService)
    : _dio = Dio(
        BaseOptions(
          baseUrl: AppConfig.baseUrl,
          headers: {'Content-Type': 'application/json'},
        ),
      ) {
    _dio.interceptors.add(
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
    );
  }

  final Dio _dio;
  final AuthApiService _authApiService;
  final SecureStorageService _secureStorageService;
  final _log = Logger('DioClient');

  // Semaphore for token refresh
  bool _isRefreshing = false;
  // Completer for waiting on token refresh finish
  Completer<void>? _refreshTokenCompleter;

  Dio get dio => _dio;

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
        case Ok<>():
         _refreshTokenCompleter!.complete();
         // Repeat original request
         return handler.next(error);
        case Error<>():
        _refreshTokenCompleter!.complete();
        // set with authrepo isauthenticated to false
      }
    } catch (e) {
      _log.severe('Error during refresh token process: $e');
      _refreshTokenCompleter!.completeError(e); // Završi s greškom
      rethrow; // Ponovno baci grešku
    } finally {
      _isRefreshing = false;
      _refreshTokenCompleter = null;
    }
  }
}
