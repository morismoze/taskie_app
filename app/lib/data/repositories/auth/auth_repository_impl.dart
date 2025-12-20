import '../../../domain/models/auth.dart';
import '../../../domain/models/user.dart';
import '../../../utils/command.dart';
import '../../services/api/auth/auth_api_service.dart';
import '../../services/api/auth/models/request/refresh_token_request.dart';
import '../../services/api/auth/models/request/social_login_request.dart';
import '../../services/api/auth/models/response/login_response.dart';
import '../../services/api/auth/models/response/refresh_token_response.dart';
import '../../services/external/google/google_auth_service.dart';
import '../../services/local/logger.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthApiService authApiService,
    required GoogleAuthService googleAuthService,
    required LoggerService loggerService,
  }) : _authApiService = authApiService,
       _googleAuthService = googleAuthService,
       _loggerService = loggerService;

  final AuthApiService _authApiService;
  final GoogleAuthService _googleAuthService;
  final LoggerService _loggerService;

  @override
  Future<Result<Auth>> signInWithGoogle() async {
    final googleIdTokenResult = await _googleAuthService.authenticate();

    if (googleIdTokenResult is Error<String>) {
      return Result.error(
        googleIdTokenResult.error,
        googleIdTokenResult.stackTrace,
      );
    }

    final googleIdToken = (googleIdTokenResult as Ok<String>).value;

    final apiLoginResult = await _authApiService.login(
      SocialLoginRequest(googleIdToken),
    );

    switch (apiLoginResult) {
      case Ok<LoginResponse>():
        final accessToken = apiLoginResult.value.accessToken;
        final refreshToken = apiLoginResult.value.refreshToken;

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
              roles: apiLoginResult.value.user.roles,
              email: apiLoginResult.value.user.email,
              profileImageUrl: apiLoginResult.value.user.profileImageUrl,
            ),
          ),
        );
      case Error<LoginResponse>():
        _loggerService.log(
          LogLevel.warn,
          'authApiService.login failed',
          error: apiLoginResult.error,
          stackTrace: apiLoginResult.stackTrace,
        );
        return Result.error(apiLoginResult.error, apiLoginResult.stackTrace);
    }
  }

  @override
  Future<Result<void>> signOut() async {
    final result = await _authApiService.logout();

    if (result is Error) {
      _loggerService.log(
        LogLevel.warn,
        'authApiService.logout failed',
        error: result.error,
        stackTrace: result.stackTrace,
      );
    }

    // Best-effort as we delete tokens an do other actual
    // UI-wise logout stuff in separate methods
    return const Result.ok(null);
  }

  @override
  Future<Result<(String, String)>> refreshToken(String? refreshToken) async {
    if (refreshToken == null) {
      return Result.error(Exception('refreshToken is null'));
    }

    final result = await _authApiService.refreshAccessToken(
      RefreshTokenRequest(refreshToken),
    );

    switch (result) {
      case Ok<RefreshTokenResponse>():
        final accessToken = result.value.accessToken;
        final refreshToken = result.value.refreshToken;
        return Result.ok((accessToken, refreshToken));
      case Error<RefreshTokenResponse>():
        _loggerService.log(
          LogLevel.warn,
          'authApiService.refreshAccessToken failed',
          error: result.error,
          stackTrace: result.stackTrace,
        );
        return Result.error(result.error, result.stackTrace);
    }
  }
}
