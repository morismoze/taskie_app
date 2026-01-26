import 'package:dio/dio.dart';

import '../../../repositories/client_info/client_info_repository.dart';

class RequestHeadersClientInfoInterceptor extends Interceptor {
  RequestHeadersClientInfoInterceptor({
    required ClientInfoRepository clientInfoRepository,
  }) : _clientInfoRepository = clientInfoRepository;

  final ClientInfoRepository _clientInfoRepository;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
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
