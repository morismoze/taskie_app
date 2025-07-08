import '../../../domain/models/auth.dart';
import '../../../utils/command.dart';

abstract class AuthRepository {
  Future<Result<Auth>> signInWithGoogle();

  Future<Result<void>> signOut();

  Future<Result<(String, String)>> refreshToken(String? refreshToken);
}
