import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../../config/environment/env.dart';
import '../../repositories/auth/auth_state_repository.dart';
import '../local/client_info_service.dart';
import 'interceptors/request_headers_interceptor.dart';
import 'interceptors/unauthorized_interceptor.dart';

class ApiDeepLinkClient {
  ApiDeepLinkClient({
    required AuthStateRepository authStateRepository,
    required ClientInfoService clientInfoService,
  }) : _authStateRepository = authStateRepository,
       _clientInfoService = clientInfoService,
       _client = Dio(
         BaseOptions(
           baseUrl: Env.deepLinkBaseUrl,
           headers: {'Content-Type': 'application/json'},
         ),
       ) {
    _client.interceptors.addAll([
      RequestHeadersInterceptor(
        authStateRepository: _authStateRepository,
        clientInfoService: _clientInfoService,
      ),
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
  final ClientInfoService _clientInfoService;

  Dio get client => _client;
}
