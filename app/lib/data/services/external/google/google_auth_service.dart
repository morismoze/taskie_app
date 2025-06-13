import 'dart:io';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:logging/logging.dart';

import '../../../../config/environment/env.dart';
import '../../../../utils/command.dart';
import 'exceptions/google_sign_in_cancelled_exception.dart';
import 'exceptions/google_sign_in_invalid_token_id_exception.dart';
import 'exceptions/google_sign_in_unknown_exception.dart';

class GoogleAuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: Platform.isIOS ? Env.googleAuthClientId : null,
    serverClientId: Platform.isAndroid ? Env.googleAuthClientId : null,
    scopes: const ['email', 'profile'],
  );
  final _log = Logger("GoogleAuthService");

  /// Returns ID token
  Future<Result<String>> authenticate() async {
    try {
      final googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return const Result.error(GoogleSignInCancelledException());
      }

      final googleAuth = await googleUser.authentication;

      if (googleAuth.idToken == null) {
        _log.severe("Invalid ID token", googleAuth);
        return Result.error(
          Exception(const GoogleSignInInvalidIdTokenException()),
        );
      }

      // After the user was successfully authenticated, we want to disconnect him out
      // which removes the user from the user information cache. This disables auto login
      // on _googleSignIn.signIn(), and prompts the account choice window wvery time.
      await GoogleSignIn().disconnect();

      return Result.ok(googleAuth.idToken!);
    } on Exception catch (e) {
      _log.severe("Failed Google sign-in or sign-out", e);
      return Result.error(Exception(const GoogleSignInUnknownException()));
    }
  }
}
