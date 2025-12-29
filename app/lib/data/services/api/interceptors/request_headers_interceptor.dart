import 'package:dio/dio.dart';

import '../../../repositories/auth/auth_state_repository.dart';
import '../../local/client_info_service.dart';

class RequestHeadersInterceptor extends Interceptor {
  RequestHeadersInterceptor({
    required AuthStateRepository authStateRepository,
    required ClientInfoService clientInfoService,
  }) : _authStateRepository = authStateRepository,
       _clientInfoService = clientInfoService;

  final AuthStateRepository _authStateRepository;
  final ClientInfoService _clientInfoService;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final (accessToken, _) = await _authStateRepository.tokens;

    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }

    final deviceModel = _clientInfoService.deviceModel;
    final deviceOsVersion = _clientInfoService.osVersion;
    final appVersion = _clientInfoService.appVersion;

    options.headers['x-device-model'] = deviceModel;
    options.headers['x-os-version'] = deviceOsVersion;
    options.headers['x-app-version'] = appVersion;

    return handler.next(options);
  }
}
