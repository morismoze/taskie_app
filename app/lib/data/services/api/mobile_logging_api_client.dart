import 'package:dio/dio.dart';

import '../../../config/environment/env.dart';
import '../../repositories/client_info/client_info_repository.dart';
import 'interceptors/request_headers_client_info_interceptor.dart';

class MobileLoggingApiClient {
  MobileLoggingApiClient({required ClientInfoRepository clientInfoRepository})
    : _clientInfoRepository = clientInfoRepository,
      _client = Dio(
        BaseOptions(
          baseUrl: Env.backendBaseUrl,
          headers: {'Content-Type': 'application/json'},
        ),
      ) {
    _client.interceptors.addAll([
      RequestHeadersClientInfoInterceptor(
        clientInfoRepository: _clientInfoRepository,
      ),
    ]);
  }

  final Dio _client;
  final ClientInfoRepository _clientInfoRepository;

  Dio get client => _client;
}
