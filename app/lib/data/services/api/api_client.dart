import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../../config/environment/env.dart';
import '../../repositories/auth/auth_state_repository.dart';
import '../local/secure_storage_service.dart';
import 'interceptors/request_headers_interceptor.dart';
import 'interceptors/unauthorized_interceptor.dart';

class ApiClient {
  ApiClient({
    required AuthStateRepository authStateRepository,
    required SecureStorageService secureStorageService,
  }) : _authStateRepository = authStateRepository,
       _secureStorageService = secureStorageService,
       _client = _instantiateApiClient(),
       _rawClient = _instantiateApiClient() {
    _client.interceptors.addAll([
      RequestHeadersInterceptor(secureStorageService: _secureStorageService),
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        enabled: Env.env != Environment.production,
      ),
      UnauthorizedInterceptor(
        mainClient: _client,
        rawClient: _rawClient,
        secureStorageService: _secureStorageService,
        authStateRepository: _authStateRepository,
      ),
    ]);
  }

  final Dio _client;
  final Dio _rawClient;
  final SecureStorageService _secureStorageService;
  final AuthStateRepository _authStateRepository;

  Dio get client => _client;

  static Dio _instantiateApiClient() {
    return Dio(
      BaseOptions(
        baseUrl: Env.backendUrl,
        headers: {'Content-Type': 'application/json'},
      ),
    );
  }
}
