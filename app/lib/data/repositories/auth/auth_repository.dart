import '../../../utils/command.dart';

abstract class AuthRepository {
  Future<Result<void>> signInWithGoogle();

  Future<Result<void>> logout();
}
