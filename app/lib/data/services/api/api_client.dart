import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../../config/environment/env.dart';
import '../../repositories/auth/auth_state_repository.dart';
import '../../repositories/client_info/client_info_repository.dart';
import '../local/auth_event_bus.dart';
import 'interceptors/forbidden_interceptor.dart';
import 'interceptors/request_headers_auth_interceptor.dart';
import 'interceptors/request_headers_client_info_interceptor.dart';
import 'interceptors/unauthorized_interceptor.dart';

class ApiClient {
  ApiClient({
    required AuthStateRepository authStateRepository,
    required ClientInfoRepository clientInfoRepository,
    required AuthEventBus authEventBus,
  }) : _authStateRepository = authStateRepository,
       _clientInfoRepository = clientInfoRepository,
       _authEventBus = authEventBus,
       _client = Dio(
         BaseOptions(
           baseUrl: Env.backendBaseUrl,
           headers: {'Content-Type': 'application/json'},
         ),
       ),
       _refreshClient = Dio(
         BaseOptions(
           baseUrl: Env.backendBaseUrl,
           headers: {'Content-Type': 'application/json'},
         ),
       ) {
    _refreshClient.interceptors.addAll([
      RequestHeadersAuthInterceptor(
        authStateRepository: _authStateRepository,
        authHeaderTokenType: AuthHeaderTokenType.refresh,
      ),
      RequestHeadersClientInfoInterceptor(
        clientInfoRepository: _clientInfoRepository,
      ),
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        enabled: Env.env != Environment.production,
      ),
    ]);

    _client.interceptors.addAll([
      RequestHeadersAuthInterceptor(
        authStateRepository: _authStateRepository,
        authHeaderTokenType: AuthHeaderTokenType.access,
      ),
      RequestHeadersClientInfoInterceptor(
        clientInfoRepository: _clientInfoRepository,
      ),
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        enabled: Env.env != Environment.production,
      ),
      UnauthorizedInterceptor(
        client: _client,
        refreshClient: _refreshClient,
        authStateRepository: _authStateRepository,
        authEventBus: _authEventBus,
      ),
      ForbiddenInterceptor(authEventBus: _authEventBus),
    ]);
  }

  final Dio _client;
  final Dio _refreshClient;
  final AuthStateRepository _authStateRepository;
  final ClientInfoRepository _clientInfoRepository;
  final AuthEventBus _authEventBus;

  Dio get client => _client;
  Dio get refreshClient => _refreshClient;
}
