import 'package:flutter/material.dart';

import '../../../data/repositories/user/user_repository.dart';
import '../../../domain/models/user.dart';
import '../../../domain/use_cases/sign_out_use_case.dart';
import '../../../utils/command.dart';

class UserProfileViewModel extends ChangeNotifier {
  UserProfileViewModel({
    required String workspaceId,
    required UserRepository userRepository,
    required SignOutUseCase signOutUserCase,
  }) : _activeWorkspaceId = workspaceId,
       _userRepository = userRepository,
       _signOutUserCase = signOutUserCase {
    _userRepository.addListener(_onUserChanged);
    loadUserDetails = Command0(_loadUserDetails)..execute();
    signOut = Command0(_signOut);
  }

  final String _activeWorkspaceId;
  final UserRepository _userRepository;
  final SignOutUseCase _signOutUserCase;

  late Command0 loadUserDetails;
  late Command0 signOut;

  String get activeWorkspaceId => _activeWorkspaceId;

  User? get details => _userRepository.user;

  void _onUserChanged() {
    notifyListeners();
  }

  Future<Result<void>> _loadUserDetails() async {
    final result = await _userRepository.loadUser().last;

    switch (result) {
      case Ok():
        return const Result.ok(null);
      case Error():
        return result;
    }
  }

  Future<Result<void>> _signOut() async {
    final result = await _signOutUserCase.signOut();

    switch (result) {
      case Ok():
        return const Result.ok(null);
      case Error():
        return result;
    }
  }

  @override
  void dispose() {
    _userRepository.removeListener(_onUserChanged);
    super.dispose();
  }
}
