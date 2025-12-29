import '../../../domain/models/user.dart';
import '../../../utils/command.dart';
import '../../services/api/user/models/response/user_response.dart';
import '../../services/api/user/user_api_service.dart';
import '../../services/local/logger.dart';
import 'user_repository.dart';

class UserRepositoryImpl extends UserRepository {
  UserRepositoryImpl({
    required UserApiService userApiService,
    required LoggerService loggerService,
  }) : _userApiService = userApiService,
       _loggerService = loggerService;

  final UserApiService _userApiService;
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
  Future<Result<User>> loadUser({bool forceFetch = false}) async {
    if (!forceFetch && _cachedUser != null) {
      return Result.ok(_cachedUser!);
    }

    final result = await _userApiService.getCurrentUser();
    switch (result) {
      case Ok<UserResponse>():
        _loggerService.setUser(result.value.id);

        final user = User(
          id: result.value.id,
          email: result.value.email,
          firstName: result.value.firstName,
          lastName: result.value.lastName,
          roles: result.value.roles,
          profileImageUrl: result.value.profileImageUrl,
          createdAt: DateTime.parse(result.value.createdAt),
        );

        _cachedUser = user;
        notifyListeners();

        return Result.ok(_cachedUser!);
      case Error<UserResponse>():
        _loggerService.log(
          LogLevel.error,
          'userApiService.getCurrentUser failed',
          error: result.error,
          stackTrace: result.stackTrace,
        );
        return Result.error(result.error);
    }
  }
}
