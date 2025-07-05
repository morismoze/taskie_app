import 'package:logging/logging.dart';

import '../../../domain/models/auth.dart';
import '../../../domain/models/user.dart';
import '../../../utils/command.dart';
import '../../services/api/auth/auth_api_service.dart';
import '../../services/api/auth/models/request/social_login_request.dart';
import '../../services/api/auth/models/response/login_response.dart';
import '../../services/external/google/google_auth_service.dart';
import 'auth_repository.dart';
import 'auth_state_repository.dart';
import 'exceptions/refresh_token_failed_exception.dart';

class AuthRepositoryImpl extends AuthRepository {
  AuthRepositoryImpl({
    required AuthApiService authApiService,
    required GoogleAuthService googleAuthService,
    required AuthStateRepository authStateRepository,
  }) : _authApiService = authApiService,
       _googleAuthService = googleAuthService,
       _authStateRepository = authStateRepository {
    _authApiService.refreshHeaderProvider = _refreshTokenProvider;
  }

  final AuthApiService _authApiService;
  final GoogleAuthService _googleAuthService;
  final AuthStateRepository _authStateRepository;

  final _log = Logger('AuthRepository');
  String? _refreshToken;

  @override
  Future<Result<Auth>> signInWithGoogle() async {
    try {
      final googleIdTokenResult = await _googleAuthService.authenticate();

      if (googleIdTokenResult is Error<String>) {
        return Result.error(googleIdTokenResult.error);
      }

      final googleIdToken = (googleIdTokenResult as Ok<String>).value;

      final apiLoginResult = await _authApiService.login(
        SocialLoginRequest(googleIdToken),
      );

      switch (apiLoginResult) {
        case Ok<LoginResponse>():
          final accessToken = apiLoginResult.value.accessToken;
          final refreshToken = apiLoginResult.value.refreshToken;

          _refreshToken = refreshToken;
          _authStateRepository.setAuthenticated(
            SetAuthStateArgumentsTrue(
              accessToken: accessToken,
              refreshToken: refreshToken,
            ),
          );

          return Result.ok(
            Auth(
              accessToken: accessToken,
              refreshToken: refreshToken,
              tokenExpires: apiLoginResult.value.tokenExpires,
              user: User(
                id: apiLoginResult.value.user.id,
                firstName: apiLoginResult.value.user.firstName,
                lastName: apiLoginResult.value.user.lastName,
                createdAt: DateTime.parse(apiLoginResult.value.user.createdAt),
                email: apiLoginResult.value.user.email,
                profileImageUrl: apiLoginResult.value.user.profileImageUrl,
              ),
            ),
          );
        case Error<LoginResponse>():
          _log.warning('Error logging in', apiLoginResult.error);
          return Result.error(apiLoginResult.error);
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<void>> signOut() async {
    try {
      final apiLogoutResult = await _authApiService.logout();

      if (apiLogoutResult is Error) {
        _log.severe('Error logging out', apiLogoutResult.error);
      }
      return const Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  /// This function is used only in specific domain cases (e.g. user created a new workspace
  /// or left an existing one). It's not used in the ApiClient (Dio) for refreshing the token on
  /// 401 - the code is duplicated there because of circular deps problem: AuthRepositoryImpl (AuthRepository)
  /// depends on AuthApiService which depends on ApiClient - on the other side if ApiClient would depend on
  /// AuthRepository, we would get circular deps problem.
  @override
  Future<Result<void>> refreshAcessToken() async {
    try {
      final result = await _authApiService.refreshAccessToken();

      switch (result) {
        case Ok():
          final accessToken = result.value.accessToken;
          final refreshToken = result.value.refreshToken;
          _refreshToken = refreshToken;
          _authStateRepository.setAuthenticated(
            SetAuthStateArgumentsTrue(
              accessToken: accessToken,
              refreshToken: refreshToken,
            ),
          );
          return const Result.ok(null);
        case Error():
          _log.severe('Error refreshing the token', result.error);
          return const Result.error(RefreshTokenFailedException());
      }
    } on Exception catch (_) {
      // signOut();
      return const Result.error(RefreshTokenFailedException());
    }
  }

  String? _refreshTokenProvider() =>
      _refreshToken != null ? 'Bearer $_refreshToken' : null;
}
