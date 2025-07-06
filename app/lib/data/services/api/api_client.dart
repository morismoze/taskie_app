import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../../config/environment/env.dart';
import '../../repositories/auth/auth_state_repository.dart';
import 'interceptors/request_headers_interceptor.dart';
import 'interceptors/unauthorized_interceptor.dart';

class ApiClient {
  ApiClient({required AuthStateRepository authStateRepository})
    : _authStateRepository = authStateRepository,
      _client = _instantiateApiClient(),
      _rawClient = _instantiateApiClient() {
    _client.interceptors.addAll([
      RequestHeadersInterceptor(authStateRepository: _authStateRepository),
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        enabled: Env.env != Environment.production,
      ),
      UnauthorizedInterceptor(
        mainClient: _client,
        rawClient: _rawClient,
        authStateRepository: _authStateRepository,
      ),
    ]);
    _rawClient.interceptors.addAll([
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        enabled: Env.env != Environment.production,
      ),
    ]);
  }

  final Dio _client;
  final Dio _rawClient;
  final AuthStateRepository _authStateRepository;

  Dio get client => _client;

  static Dio _instantiateApiClient() {
    return Dio(
      BaseOptions(
        baseUrl: Env.backendUrl,
        headers: {'Content-Type': 'application/json'},
      ),
    );
  }
}
