import 'package:flutter/material.dart';

import '../../../utils/command.dart';

abstract class AuthStateRepository extends ChangeNotifier {
  /// Returns true when the user is logged in
  /// Returns [Future] because it will load a stored auth state the first time.
  Future<bool> get isAuthenticated;

  /// This method is used to set authenticated state. It accepts either `null` which
  /// represents unauthenticated state or a record (String accessToken, String refreshToken)
  /// which represents authenticated state.
  Future<Result<void>> setAuthenticated((String, String)? tokens);

  /// Returns a record of current tokens (String accessToken, String refreshToken).
  Future<(String?, String?)> get tokens;
}
