import 'package:flutter/foundation.dart';

import '../../../utils/command.dart';

abstract class AuthStateRepository extends ChangeNotifier {
  /// Returns true when the user is logged in. It is initially set to `false`
  /// because this will be set on app startup, which happens before gorouter
  /// (and hence its redirect function) - in that setup it will either be set
  /// to `true` or remain false (or set to `false` again).
  bool get isAuthenticated;

  /// Loads from the storage. This is done once, in the AppStartup widget.
  Future<bool> loadAuthenticatedState();

  /// Sets authenticated state.
  void setAuthenticated(bool isAuthenticated);

  /// Sets tokens (String accessToken, String refreshToken) to storage.
  /// `null` argument means setting tokens to null in the storage.
  Future<Result<void>> setTokens((String, String)? tokens);

  /// Returns a record of current tokens (String accessToken, String refreshToken).
  Future<(String?, String?)> get tokens;
}
