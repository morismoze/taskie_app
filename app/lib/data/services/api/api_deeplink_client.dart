import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../../config/environment/env.dart';
import '../../repositories/auth/auth_state_repository.dart';
import 'interceptors/request_headers_interceptor.dart';
import 'interceptors/unauthorized_interceptor.dart';

class ApiDeepLinkClient {
  ApiDeepLinkClient({required AuthStateRepository authStateRepository})
    : _authStateRepository = authStateRepository,
      _client = Dio(
        BaseOptions(
          baseUrl: Env.deepLinkBaseUrl,
          headers: {'Content-Type': 'application/json'},
        ),
      ) {
    _client.interceptors.addAll([
      RequestHeadersInterceptor(authStateRepository: _authStateRepository),
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        enabled: Env.env != Environment.production,
      ),
      UnauthorizedInterceptor(
        client: _client,
        authStateRepository: _authStateRepository,
      ),
    ]);
  }

  final Dio _client;
  final AuthStateRepository _authStateRepository;

  Dio get client => _client;
}
