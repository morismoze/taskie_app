import 'package:dio/dio.dart';

import '../../../repositories/auth/auth_state_repository.dart';

class RequestHeadersInterceptor extends Interceptor {
  RequestHeadersInterceptor({required AuthStateRepository authStateRepository})
    : _authStateRepository = authStateRepository;

  final AuthStateRepository _authStateRepository;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final (accessToken, _) = await _authStateRepository.tokens;

    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }

    return handler.next(options);
  }
}
