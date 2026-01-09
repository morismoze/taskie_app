import 'package:flutter/material.dart';

import '../../../data/repositories/user/user_repository.dart';
import '../../../domain/models/user.dart';
import '../../../domain/use_cases/sign_out_use_case.dart';
import '../../../utils/command.dart';

class UserProfileViewModel extends ChangeNotifier {
  UserProfileViewModel({
    required String workspaceId,
    required UserRepository userRepository,
    required SignOutUseCase signOutUseCase,
  }) : _activeWorkspaceId = workspaceId,
       _userRepository = userRepository,
       _signOutUseCase = signOutUseCase {
    _userRepository.addListener(_onUserChanged);
    loadUserDetails = Command0(_loadUserDetails)..execute();
    signOut = Command0(_signOut);
    deleteAccount = Command0(_deleteAccount);
  }

  final String _activeWorkspaceId;
  final UserRepository _userRepository;
  final SignOutUseCase _signOutUseCase;

  late Command0 loadUserDetails;
  late Command0 signOut;
  late Command0 deleteAccount;

  String get activeWorkspaceId => _activeWorkspaceId;

  User? get details => _userRepository.user;

  void _onUserChanged() {
    notifyListeners();
  }

  Future<Result<void>> _loadUserDetails() async {
    final result = await firstOkOrLastError(_userRepository.loadUser());

    switch (result) {
      case Ok():
        return const Result.ok(null);
      case Error():
        return result;
    }
  }

  Future<Result<void>> _signOut() async {
    final result = await _signOutUseCase.signOut();

    switch (result) {
      case Ok():
        return const Result.ok(null);
      case Error():
        return result;
    }
  }

  Future<Result<void>> _deleteAccount() async {
    return Future.delayed(const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _userRepository.removeListener(_onUserChanged);
    super.dispose();
  }
}
