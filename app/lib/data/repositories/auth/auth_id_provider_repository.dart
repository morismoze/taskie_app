import '../../../utils/command.dart';

// Only Google for now
enum AuthProvider { google }

class ExternalCredential {
  ExternalCredential({required this.idToken});
  final String idToken;
}

abstract class AuthIdProviderRepository {
  AuthProvider get type;
  Future<Result<ExternalCredential>> signIn();
  Future<Result<void>> signOut();
}
