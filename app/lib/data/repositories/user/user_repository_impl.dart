import '../../../domain/models/user.dart';
import '../../../utils/command.dart';
import '../../services/api/user/models/response/user_response.dart';
import '../../services/api/user/user_api_service.dart';
import 'user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl({required UserApiService userApiService})
    : _userApiService = userApiService;

  final UserApiService _userApiService;

  User? _cachedData;

  @override
  Result<void> setUser(User user) {
    _cachedData = user;
    return const Result.ok(null);
  }

  @override
  Future<Result<User>> getUser() async {
    if (_cachedData != null) {
      return Future.value(Result.ok(_cachedData!));
    }

    final result = await _userApiService.getCurrentUser();
    switch (result) {
      case Ok<UserResponse>():
        final user = User(
          id: result.value.id,
          email: result.value.email,
          firstName: result.value.firstName,
          lastName: result.value.lastName,
          profileImageUrl: result.value.profileImageUrl,
          createdAt: DateTime.parse(result.value.createdAt),
        );

        setUser(user);

        return Result.ok(user);
      case Error<UserResponse>():
        return Result.error(result.error);
    }
  }
}
