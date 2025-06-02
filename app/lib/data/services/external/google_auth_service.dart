import 'package:google_sign_in/google_sign_in.dart';
import 'package:logging/logging.dart';

import '../../../utils/command.dart';

enum GoogleSignInResult { cancelled, missingIdToken }

class GoogleAuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    // Scopes are defined in the Google console for the backend. Frontend
    // only needs the token ID so it can send it to backend
    scopes: const [],
  );
  final _log = Logger("GoogleAuthService");

  /// Returns ID token
  Future<Result<String?>> authenticate() async {
    try {
      final googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return Result.error(Exception(GoogleSignInResult.cancelled));
      }

      final googleAuth = await googleUser.authentication;

      if (googleAuth.idToken == null) {
        return Result.error(Exception(GoogleSignInResult.missingIdToken));
      }

      return Result.ok(googleAuth.idToken);
    } on Exception catch (e) {
      _log.severe("Failed Google sign-in", e);
      return Result.error(e);
    }
  }
}
