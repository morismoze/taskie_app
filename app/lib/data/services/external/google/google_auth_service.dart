import 'package:google_sign_in/google_sign_in.dart';

import '../../../../config/environment/env.dart';
import '../../../../utils/command.dart';
import 'exceptions/google_sign_in_cancelled_exception.dart';
import 'exceptions/google_sign_in_invalid_token_id_exception.dart';
import 'exceptions/google_sign_in_unknown_exception.dart';

class GoogleAuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: Env.googleAuthClientId,
    serverClientId: Env.googleAuthClientId,
    scopes: const ['email', 'profile'],
  );

  /// Returns ID token
  Future<Result<String>> authenticate() async {
    try {
      var googleUser = await _googleSignIn.signInSilently();

      // Check if a Google session is still active
      if (googleUser != null) {
        final googleAuth = await googleUser.authentication;

        if (googleAuth.idToken == null) {
          // Invalid ID token on silent sign-in
        } else {
          return Result.ok(googleAuth.idToken!);
        }
      }

      // Fallback: no active/usable session → prompt user interactively.
      googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return const Result.error(GoogleSignInCancelledException());
      }

      final googleAuth = await googleUser.authentication;

      if (googleAuth.idToken == null) {
        return Result.error(
          Exception(const GoogleSignInInvalidIdTokenException()),
        );
      }

      // This should be done when user manually signs out
      // await _googleSignIn.disconnect();

      return Result.ok(googleAuth.idToken!);
    } on Exception catch (e, stackTrace) {
      return Result.error(
        Exception(const GoogleSignInUnknownException()),
        stackTrace,
      );
    }
  }
}
