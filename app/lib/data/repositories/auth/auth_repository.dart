import '../../../domain/models/auth.dart';
import '../../../utils/command.dart';
import 'auth_id_provider_repository.dart';

abstract class AuthRepository {
  Future<Result<Auth>> signIn(AuthProvider provider);

  Future<Result<void>> signOut();

  Future<Result<(String, String)>> refreshToken();
}
