import 'package:dio/dio.dart';

import '../../../../utils/command.dart';
import '../../local/secure_storage_service.dart'; // Uvezi SecureStorageService

class RequestHeadersInterceptor extends Interceptor {
  RequestHeadersInterceptor({
    required SecureStorageService secureStorageService,
  }) : _secureStorageService = secureStorageService;

  final SecureStorageService _secureStorageService;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final accessTokenResult = await _secureStorageService.getAccessToken();
    switch (accessTokenResult) {
      case Ok<String?>():
        if (accessTokenResult.value != null) {
          options.headers['Authorization'] =
              'Bearer ${accessTokenResult.value}';
        }
        break;
      default:
    }
    return handler.next(options);
  }
}
