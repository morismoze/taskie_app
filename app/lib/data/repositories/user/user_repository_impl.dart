import '../../../domain/models/user.dart';
import '../../../utils/command.dart';
import '../../services/api/user/models/response/user_response.dart';
import '../../services/api/user/user_api_service.dart';
import 'user_repository.dart';

class UserRepositoryImpl extends UserRepository {
  UserRepositoryImpl({required UserApiService userApiService})
    : _userApiService = userApiService;

  final UserApiService _userApiService;

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
        return Result.error(result.error);
    }
  }
}
