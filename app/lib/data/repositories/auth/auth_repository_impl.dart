import '../../../domain/models/auth.dart';
import '../../../domain/models/user.dart';
import '../../../utils/command.dart';
import '../../services/api/auth/auth_api_service.dart';
import '../../services/api/auth/models/request/social_login_request.dart';
import '../../services/api/auth/models/response/login_response.dart';
import '../../services/api/auth/models/response/refresh_token_response.dart';
import '../../services/local/logger_service.dart';
import '../../services/local/shared_preferences_service.dart';
import 'auth_id_provider_repository.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthApiService authApiService,
    required SharedPreferencesService sharedPreferencesService,
    required Map<AuthProvider, AuthIdProviderRepository> providers,
    required LoggerService loggerService,
  }) : _authApiService = authApiService,
       _sharedPreferencesService = sharedPreferencesService,
       _providers = providers,
       _loggerService = loggerService;

  final AuthApiService _authApiService;
  final SharedPreferencesService _sharedPreferencesService;
  final Map<AuthProvider, AuthIdProviderRepository> _providers;
  final LoggerService _loggerService;

  AuthProvider? _activeProvider;

  Future<Result<AuthProvider?>> _getActiveProvider() async {
    if (_activeProvider != null) {
      return Result.ok(_activeProvider);
    }

    final resultGetActiveAuthIdProvider = await _sharedPreferencesService
        .getActiveAuthIdProvider();

    switch (resultGetActiveAuthIdProvider) {
      case Ok<AuthProvider?>():
        _activeProvider = resultGetActiveAuthIdProvider.value;
        return Result.ok(resultGetActiveAuthIdProvider.value);
      case Error<AuthProvider?>():
        _loggerService.log(
          LogLevel.warn,
          'sharedPreferencesService.getActiveAuthIdProvider failed',
          error: resultGetActiveAuthIdProvider.error,
          stackTrace: resultGetActiveAuthIdProvider.stackTrace,
        );
        return Result.error(
          resultGetActiveAuthIdProvider.error,
          resultGetActiveAuthIdProvider.stackTrace,
        );
    }
  }

  @override
  Future<Result<Auth>> signIn(AuthProvider provider) async {
    final extProvider = _providers[provider];
    if (extProvider == null) {
      return Result.error(Exception('Provider not supported'));
    }

    final idProviderResult = await extProvider.signIn();

    if (idProviderResult is Error<ExternalCredential>) {
      _loggerService.log(
        LogLevel.warn,
        'extProvider.signIn failed',
        error: idProviderResult.error,
        stackTrace: idProviderResult.stackTrace,
      );
      return Result.error(idProviderResult.error, idProviderResult.stackTrace);
    }

    final idToken = (idProviderResult as Ok<ExternalCredential>).value.idToken;

    final apiLoginResult = await _authApiService.login(
      provider: provider,
      payload: SocialLoginRequest(idToken),
    );

    switch (apiLoginResult) {
      case Ok<LoginResponse>():
        final accessToken = apiLoginResult.value.accessToken;
        final refreshToken = apiLoginResult.value.refreshToken;
        _activeProvider = provider;

        // We need to save active provider to the disk once a user
        // signed in via that provider.
        final resultSetActiveAuthIdProvider = await _sharedPreferencesService
            .setActiveAuthIdProvider(provider: provider);

        if (resultSetActiveAuthIdProvider is Error) {
          _loggerService.log(
            LogLevel.warn,
            'sharedPreferencesService.setActiveAuthIdProvider failed',
            error: resultSetActiveAuthIdProvider.error,
            stackTrace: resultSetActiveAuthIdProvider.stackTrace,
          );
          return Result.error(
            resultSetActiveAuthIdProvider.error,
            resultSetActiveAuthIdProvider.stackTrace,
          );
        }

        _loggerService.setUser(apiLoginResult.value.user.id);

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
        // If the actual API request failed, we need to sign the user out
        // of the provider to keep the state clean, meaning not have the
        // user signed in on the provider, but not on our API.
        final resultSignOutIdProvider = await extProvider.signOut();
        if (resultSignOutIdProvider is Error) {
          _loggerService.log(
            LogLevel.warn,
            'extProvider.signOut (cleanup) failed',
            error: resultSignOutIdProvider.error,
            stackTrace: resultSignOutIdProvider.stackTrace,
          );
        }

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
    // Get active provider
    final resultActiveProvider = await _getActiveProvider();

    if (resultActiveProvider is Error<AuthProvider?>) {
      return Result.error(
        resultActiveProvider.error,
        resultActiveProvider.stackTrace,
      );
    }

    final resultApiLogout = await _authApiService.logout();

    if (resultApiLogout is Error) {
      // No need to return error result, because not logouting
      // on the backend is not fatal
      _loggerService.log(
        LogLevel.warn,
        'authApiService.logout failed',
        error: resultApiLogout.error,
        stackTrace: resultApiLogout.stackTrace,
      );
    }

    final activeProvider = (resultActiveProvider as Ok<AuthProvider?>).value!;
    final extProvider = _providers[activeProvider]!;
    final resultIdProviderSignOut = await extProvider.signOut();

    if (resultIdProviderSignOut is Error) {
      _loggerService.log(
        LogLevel.warn,
        'extProvider.signOut failed',
        error: resultIdProviderSignOut.error,
        stackTrace: resultIdProviderSignOut.stackTrace,
      );
    }

    // No need to check the result, as user will override it again
    // on the next sign in
    await _sharedPreferencesService.deleteActiveAuthIdProvider();
    _activeProvider = null;
    // Best-effort as we delete tokens and do other actual
    // UI-wise logout stuff in separate methods
    return const Result.ok(null);
  }

  @override
  Future<Result<(String, String)>> refreshToken() async {
    final result = await _authApiService.refreshAccessToken();

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
