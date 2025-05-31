import 'package:logging/logging.dart';

import '../../../utils/command.dart';
import '../../services/external/google/auth/google_auth_service.dart';
import '../../services/local/secure_storage_service.dart';
import 'auth_repository.dart';

class AuthRepository extends BaseAuthRepository {
  AuthRepository({
    required ApiClient apiClient,
    required GoogleAuthService googleAuthService,
    required SecureStorageService secureStorageService,
  }) : _apiClient = apiClient,
       _googleAuthService = googleAuthService,
       _secureStorageService = secureStorageService;

  final ApiClient _apiClient;
  final GoogleAuthService _googleAuthService;
  final SecureStorageService _secureStorageService;

  bool? _isAuthenticated;
  String? _authToken;
  final _log = Logger('AuthRepository');

  @override
  Future<bool> get isAuthenticated async {
    // Status is cached
    if (_isAuthenticated != null) {
      return _isAuthenticated!;
    }

    // Status is not cached, fetch from storage
    final result = await _secureStorageService.getAccessToken();
    switch (result) {
      case Ok<String?>():
        _authToken = result.value;
        _isAuthenticated = result.value != null;
      case Error<String?>():
        _log.severe(
          'Failed to fetch access token from secure storage',
          result.error,
        );
    };

    return _isAuthenticated ?? false;
  }

  @override
  Future<Result<void>> loginWithGoogle() async {
    final googleIdTokenResult = await _googleAuthService.authenticate();

    if (googleIdTokenResult is Error<String>) {
      return googleIdTokenResult;
    }

    final googleIdToken = (googleIdTokenResult as Ok<String>).value;

    final apiResponseResult = 
  }

  @override
  Future<Result<void>> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }
}
