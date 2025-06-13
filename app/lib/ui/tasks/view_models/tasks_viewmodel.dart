import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import '../../../data/repositories/user/user_repository.dart';
import '../../../domain/models/user.dart';
import '../../../utils/command.dart';

class TasksViewModel extends ChangeNotifier {
  TasksViewModel({required UserRepository userRepository})
    : _userRepository = userRepository {
    loadUser = Command0(_loadUser)..execute();
  }

  final UserRepository _userRepository;
  final _log = Logger('TasksViewModel');

  late Command0 loadUser;

  User? _user;

  User? get user => _user;

  Future<Result<void>> _loadUser() async {
    final result = await _userRepository.getUser();

    switch (result) {
      case Ok():
        _user = result.value;
        notifyListeners();
      case Error():
        _log.warning('Failed to load user', result.error);
    }

    return result;
  }
}
