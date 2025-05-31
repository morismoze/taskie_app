import 'package:logging/logging.dart';

import '../../../utils/command.dart';
import '../../services/api/auth/auth_api_service.dart';
import '../../services/api/auth/models/request/social_login_request.dart';
import '../../services/api/auth/models/response/login_response.dart';
import '../../services/external/google_auth_service.dart';
import '../../services/local/secure_storage_service.dart';
import 'auth_repository.dart';

class AuthRepository extends BaseAuthRepository {
  AuthRepository({
    required AuthApiService authApiService,
    required GoogleAuthService googleAuthService,
    required SecureStorageService secureStorageService,
  }) : _authApiService = authApiService,
       _googleAuthService = googleAuthService,
       _secureStorageService = secureStorageService;

  final AuthApiService _authApiService;
  final GoogleAuthService _googleAuthService;
  final SecureStorageService _secureStorageService;

  bool? _isAuthenticated;
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
        _isAuthenticated = result.value != null;
      case Error<String?>():
        _log.severe(
          'Failed to fetch access token from secure storage',
          result.error,
        );
    }

    return _isAuthenticated ?? false;
  }

  @override
  Future<Result<void>> loginWithGoogle() async {
    final googleIdTokenResult = await _googleAuthService.authenticate();

    if (googleIdTokenResult is Error<String>) {
      return googleIdTokenResult;
    }

    final googleIdToken = (googleIdTokenResult as Ok<String>).value;

    final apiResponseResult = await _authApiService.login(
      SocialLoginRequest(googleIdToken),
    );

    switch (apiResponseResult) {
      case Ok<LoginResponse>():
        _isAuthenticated = true;
        return await _secureStorageService.setAccessToken(
          apiResponseResult.value.accessToken,
        );
      case Error<LoginResponse>():
        _log.warning('Error logging in', apiResponseResult.error);
        return Result.error(apiResponseResult.error);
    }
  }

  @override
  Future<Result<void>> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }
}
