import 'package:flutter/material.dart';

import '../../../domain/models/user.dart';
import '../../../utils/command.dart';

/// This is a [ChangeNotifier] because user will be able to
/// pull-down-to-refresh which will also trigger new
/// user request and which can result in changed user data.
abstract class UserRepository extends ChangeNotifier {
  User? get user;

  /// Set current user
  void setUser(User user);

  /// Get current user
  Future<Result<User>> loadUser({bool forceFetch = false});
}
