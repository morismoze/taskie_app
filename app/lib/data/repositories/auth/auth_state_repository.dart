import 'package:flutter/material.dart';

sealed class SetAuthStateArguments {
  const SetAuthStateArguments();
}

final class SetAuthStateArgumentsTrue extends SetAuthStateArguments {
  const SetAuthStateArgumentsTrue({
    required this.accessToken,
    required this.refreshToken,
  });

  final String accessToken;
  final String refreshToken;
}

final class SetAuthStateArgumentsFalse extends SetAuthStateArguments {
  const SetAuthStateArgumentsFalse();
}

abstract class AuthStateRepository extends ChangeNotifier {
  /// Returns true when the user is logged in
  /// Returns [Future] because it will load a stored auth state the first time.
  Future<bool> get isAuthenticated;

  void setAuthenticated(SetAuthStateArguments args);
}
