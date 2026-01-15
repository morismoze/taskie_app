import 'package:dio/dio.dart';

import '../../../repositories/auth/auth_state_repository.dart';
import '../../local/client_info_service.dart';

enum AuthHeaderTokenType { access, refresh }

class RequestHeadersInterceptor extends Interceptor {
  RequestHeadersInterceptor({
    required AuthStateRepository authStateRepository,
    required ClientInfoService clientInfoService,
    AuthHeaderTokenType authHeaderTokenType = AuthHeaderTokenType.access,
  }) : _authStateRepository = authStateRepository,
       _clientInfoService = clientInfoService,
       _authHeaderTokenType = authHeaderTokenType;

  final AuthStateRepository _authStateRepository;
  final ClientInfoService _clientInfoService;
  final AuthHeaderTokenType _authHeaderTokenType;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final (accessToken, refreshToken) = await _authStateRepository.tokens;
    String? token;
    switch (_authHeaderTokenType) {
      case AuthHeaderTokenType.access:
        token = accessToken;
        break;
      case AuthHeaderTokenType.refresh:
        token = refreshToken;
        break;
    }
    options.headers['Authorization'] = 'Bearer $token';

    final deviceModel = _clientInfoService.deviceModel;
    final deviceOsVersion = _clientInfoService.osVersion;
    final appVersion = _clientInfoService.appVersion;

    options.headers['x-device-model'] = deviceModel;
    options.headers['x-os-version'] = deviceOsVersion;
    options.headers['x-app-version'] = appVersion;

    return handler.next(options);
  }
}
