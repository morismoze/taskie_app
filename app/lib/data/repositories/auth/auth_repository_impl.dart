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

class AuthRepositoryImpl extends AuthRepository {
  AuthRepositoryImpl({
    required AuthApiService authApiService,
    required GoogleAuthService googleAuthService,
    required AuthStateRepository authStateRepository,
  }) : _authApiService = authApiService,
       _googleAuthService = googleAuthService;

  final AuthApiService _authApiService;
  final GoogleAuthService _googleAuthService;

  final _log = Logger('AuthRepository');

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
}
