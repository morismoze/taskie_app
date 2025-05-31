import 'package:flutter/material.dart';

import '../../../utils/command.dart';

abstract class BaseAuthRepository extends ChangeNotifier {
  /// Returns true when the user is logged in
  /// Returns [Future] because it will load a stored auth state the first time.
  Future<bool> get isAuthenticated;

  Future<Result<void>> loginWithGoogle();

  Future<Result<void>> logout();
}
