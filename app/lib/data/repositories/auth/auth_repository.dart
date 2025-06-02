import '../../../utils/command.dart';

abstract class AuthRepository {
  Future<Result<void>> loginWithGoogle();

  Future<Result<void>> logout();
}
