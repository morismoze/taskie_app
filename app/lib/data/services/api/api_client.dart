import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../../config/environment/env.dart';
import '../../repositories/auth/auth_state_repository.dart';
import '../local/auth_event_bus.dart';
import '../local/client_info_service.dart';
import 'interceptors/forbidden_interceptor.dart';
import 'interceptors/request_headers_interceptor.dart';
import 'interceptors/unauthorized_interceptor.dart';

class ApiClient {
  ApiClient({
    required AuthStateRepository authStateRepository,
    required ClientInfoService clientInfoService,
    required AuthEventBus authEventBus,
  }) : _authStateRepository = authStateRepository,
       _clientInfoService = clientInfoService,
       _authEventBus = authEventBus,
       _client = Dio(
         BaseOptions(
           baseUrl: Env.backendUrl,
           headers: {'Content-Type': 'application/json'},
         ),
       ),
       _refreshClient = Dio(
         BaseOptions(
           baseUrl: Env.backendUrl,
           headers: {'Content-Type': 'application/json'},
         ),
       ) {
    _refreshClient.interceptors.addAll([
      RequestHeadersInterceptor(
        authStateRepository: _authStateRepository,
        clientInfoService: _clientInfoService,
        authHeaderTokenType: AuthHeaderTokenType.refresh,
      ),
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        enabled: Env.env != Environment.production,
      ),
    ]);

    _client.interceptors.addAll([
      RequestHeadersInterceptor(
        authStateRepository: _authStateRepository,
        clientInfoService: _clientInfoService,
        authHeaderTokenType: AuthHeaderTokenType.access,
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
  final ClientInfoService _clientInfoService;
  final AuthEventBus _authEventBus;

  Dio get client => _client;
  Dio get refreshClient => _refreshClient;
}
