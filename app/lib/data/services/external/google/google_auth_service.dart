import 'package:google_sign_in/google_sign_in.dart';
import 'package:logging/logging.dart';

import '../../../../config/environment/env.dart';
import '../../../../utils/command.dart';
import 'exceptions/google_sign_in_cancelled_exception.dart';
import 'exceptions/google_sign_in_invalid_token_id_exception.dart';
import 'exceptions/google_sign_in_unknown_exception.dart';

class GoogleAuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: Env.googleAuthClientId,
    // Scopes are defined in the Google console for the backend. Frontend
    // only needs the token ID so it can send it to backend
    scopes: const [
      'https://www.googleapis.com/auth/userinfo.email',
      'https://www.googleapis.com/auth/userinfo.profile',
    ],
  );
  final _log = Logger("GoogleAuthService");

  /// Returns ID token
  Future<Result<String>> authenticate() async {
    try {
      final googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return Result.error(GoogleSignInCancelledException());
      }

      final googleAuth = await googleUser.authentication;

      if (googleAuth.idToken == null) {
        _log.severe("Invalid ID token", googleAuth);
        return Result.error(Exception(GoogleSignInInvalidIdTokenException()));
      }

      return Result.ok(googleAuth.idToken!);
    } on Exception catch (e) {
      _log.severe("Failed Google sign-in", e);
      return Result.error(Exception(GoogleSignInUnknownException()));
    }
  }
}
