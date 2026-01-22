import 'package:flutter/material.dart';

import '../../../domain/models/user.dart';
import '../../../utils/command.dart';

abstract class UserRepository extends ChangeNotifier {
  User? get user;

  /// Set current user
  void setUser(User user);

  /// Get current user
  Stream<Result<User>> loadUser({bool forceFetch = false});

  Future<Result<void>> deleteAccount();

  Future<void> purgeUserCache();
}
