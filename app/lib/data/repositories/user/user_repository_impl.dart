import '../../../domain/models/user.dart';
import '../../../logger/logger_interface.dart';
import '../../../utils/command.dart';
import '../../services/api/user/models/response/user_response.dart';
import '../../services/api/user/user_api_service.dart';
import '../../services/local/database_service.dart';
import 'user_repository.dart';

class UserRepositoryImpl extends UserRepository {
  UserRepositoryImpl({
    required UserApiService userApiService,
    required DatabaseService databaseService,
    required LoggerService loggerService,
  }) : _userApiService = userApiService,
       _databaseService = databaseService,
       _loggerService = loggerService;

  final UserApiService _userApiService;
  final DatabaseService _databaseService;
  final LoggerService _loggerService;

  User? _cachedUser;

  @override
  User? get user => _cachedUser;

  @override
  void setUser(User user) {
    _cachedUser = user;
    notifyListeners();
  }

  @override
  Stream<Result<User>> loadUser({bool forceFetch = false}) async* {
    // Read from in-memory cache
    if (!forceFetch && _cachedUser != null) {
      yield Result.ok(_cachedUser!);
    }

    // Read from DB cache
    if (!forceFetch) {
      final dbResult = await _databaseService.getUser();
      if (dbResult is Ok<User?>) {
        final dbUser = dbResult.value;
        if (dbUser != null) {
          _cachedUser = dbUser;
          notifyListeners();
          yield Result.ok(dbUser);
        }
      }
    }

    // Trigger API request
    final apiResult = await _userApiService.getCurrentUser();
    switch (apiResult) {
      case Ok<UserResponse>():
        final user = User(
          id: apiResult.value.id,
          email: apiResult.value.email,
          firstName: apiResult.value.firstName,
          lastName: apiResult.value.lastName,
          roles: apiResult.value.roles,
          profileImageUrl: apiResult.value.profileImageUrl,
          createdAt: DateTime.parse(apiResult.value.createdAt),
        );

        final dbSaveResult = await _databaseService.setUser(user);
        if (dbSaveResult is Error<void>) {
          _loggerService.log(
            LogLevel.warn,
            'databaseService.setUser failed',
            error: dbSaveResult.error,
            stackTrace: dbSaveResult.stackTrace,
            context: 'UserRepositoryImpl',
          );
        }

        _cachedUser = user;
        notifyListeners();

        yield Result.ok(_cachedUser!);
      case Error<UserResponse>():
        _loggerService.log(
          LogLevel.error,
          'userApiService.getCurrentUser failed',
          error: apiResult.error,
          stackTrace: apiResult.stackTrace,
          context: 'UserRepositoryImpl',
        );
        yield Result.error(apiResult.error);
    }
  }

  @override
  Future<Result<void>> deleteAccount() async {
    final apiResult = await _userApiService.deleteAccount();
    switch (apiResult) {
      case Ok():
        return const Result.ok(null);
      case Error():
        _loggerService.log(
          LogLevel.error,
          'userApiService.getCurrentUser failed',
          error: apiResult.error,
          stackTrace: apiResult.stackTrace,
          context: 'UserRepositoryImpl',
        );
        return Result.error(apiResult.error);
    }
  }

  @override
  Future<void> purgeUserCache() async {
    _cachedUser = null;
    await _databaseService.clearUser();
  }
}
