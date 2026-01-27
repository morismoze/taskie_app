import 'package:dio/dio.dart';

import '../../../repositories/auth/auth_state_repository.dart';

enum AuthHeaderTokenType { access, refresh }

class RequestHeadersAuthInterceptor extends Interceptor {
  RequestHeadersAuthInterceptor({
    required AuthStateRepository authStateRepository,
    AuthHeaderTokenType authHeaderTokenType = AuthHeaderTokenType.access,
  }) : _authStateRepository = authStateRepository,
       _authHeaderTokenType = authHeaderTokenType;

  final AuthStateRepository _authStateRepository;
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

    return handler.next(options);
  }
}
