import 'package:logging/logging.dart';

import '../../../utils/command.dart';
import '../../services/api/auth/auth_api_service.dart';
import '../../services/api/auth/models/request/social_login_request.dart';
import '../../services/api/auth/models/response/login_response.dart';
import '../../services/external/google/google_auth_service.dart';
import 'auth_repository.dart';
import 'auth_state_repository.dart';

class AuthRepositoryImpl extends AuthRepository {
  AuthRepositoryImpl({
    required AuthStateRepository authStateRepository,
    required AuthApiService authApiService,
    required GoogleAuthService googleAuthService,
  }) : _authStateRepository = authStateRepository,
       _authApiService = authApiService,
       _googleAuthService = googleAuthService;

  final AuthStateRepository _authStateRepository;
  final AuthApiService _authApiService;
  final GoogleAuthService _googleAuthService;

  final _log = Logger('AuthRepository');

  @override
  Future<Result<void>> signInWithGoogle() async {
    try {
      final googleIdTokenResult = await _googleAuthService.authenticate();

      if (googleIdTokenResult is Error<String>) {
        return googleIdTokenResult;
      }

      final googleIdToken = (googleIdTokenResult as Ok<String>).value;

      final apiLoginResult = await _authApiService.login(
        SocialLoginRequest(googleIdToken),
      );

      switch (apiLoginResult) {
        case Ok<LoginResponse>():
          final accessToken = apiLoginResult.value.accessToken;
          final refreshToken = apiLoginResult.value.accessToken;
          _authStateRepository.setAuthenticated(
            SetAuthStateArgumentsTrue(
              accessToken: accessToken,
              refreshToken: refreshToken,
            ),
          );
          return Result.ok(null);
        case Error<LoginResponse>():
          _log.warning('Error logging in', apiLoginResult.error);
          return Result.error(apiLoginResult.error);
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      final apiLogoutResult = await _authApiService.logout();

      if (apiLogoutResult is Error) {
        _log.severe('Error logging out', apiLogoutResult.error);
      }

      _authStateRepository.setAuthenticated(SetAuthStateArgumentsFalse());
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}
