import 'package:dio/dio.dart';

import '../../../repositories/auth/auth_state_repository.dart';
import '../../../repositories/client_info/client_info_repository.dart';

enum AuthHeaderTokenType { access, refresh }

class RequestHeadersInterceptor extends Interceptor {
  RequestHeadersInterceptor({
    required AuthStateRepository authStateRepository,
    required ClientInfoRepository clientInfoRepository,
    AuthHeaderTokenType authHeaderTokenType = AuthHeaderTokenType.access,
  }) : _authStateRepository = authStateRepository,
       _clientInfoRepository = clientInfoRepository,
       _authHeaderTokenType = authHeaderTokenType;

  final AuthStateRepository _authStateRepository;
  final ClientInfoRepository _clientInfoRepository;
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

    final deviceModel = _clientInfoRepository.clientInfo.deviceModel;
    final deviceOsVersion = _clientInfoRepository.clientInfo.osVersion;
    final appVersion = _clientInfoRepository.clientInfo.appVersion;
    final buildNumber = _clientInfoRepository.clientInfo.buildNumber;

    options.headers['x-device-model'] = deviceModel;
    options.headers['x-os-version'] = deviceOsVersion;
    options.headers['x-app-version'] = appVersion;
    options.headers['x-build-number'] = buildNumber;

    return handler.next(options);
  }
}
