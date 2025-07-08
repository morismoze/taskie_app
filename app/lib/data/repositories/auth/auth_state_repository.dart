import 'package:flutter/material.dart';

import '../../../utils/command.dart';

abstract class AuthStateRepository extends ChangeNotifier {
  /// Returns true when the user is logged in
  /// Returns [Future] because it will load a stored auth state the first time.
  Future<bool> get isAuthenticated;

  /// Sets authenticated state.
  void setAuthenticated(bool isAuthenticated);

  /// Sets tokens (String accessToken, String refreshToken) to storage.
  /// `null` argument means setting tokens to null in the storage.
  Future<Result<void>> setTokens((String, String)? tokens);

  /// Returns a record of current tokens (String accessToken, String refreshToken).
  Future<(String?, String?)> get tokens;
}
