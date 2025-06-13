import '../../../domain/models/user.dart';
import '../../../utils/command.dart';

abstract class UserRepository {
  /// Set current user
  Result<void> setUser(User user);

  /// Get current user
  Future<Result<User>> getUser();
}
