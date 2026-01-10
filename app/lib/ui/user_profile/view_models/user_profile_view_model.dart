import 'package:flutter/material.dart';

import '../../../data/repositories/user/user_repository.dart';
import '../../../data/services/api/user/models/response/user_response.dart';
import '../../../domain/models/user.dart';
import '../../../domain/use_cases/sign_out_use_case.dart';
import '../../../utils/command.dart';

/// We need user profile also on the CreateWorkspaceInitialScreen
/// because of two scenarios:
/// 1. User accidentally logs in with wrong account which doesn't have
/// any workspaces, and so the user can log out.
/// 2. User tries deleting account on the homepage (tasks screen)
/// but in all the workspaces he is part of he is the last Manager.
/// In that case user needs to leave all the workspaces (unless
/// the user promotes someone else to Manager role). When user
/// leaves all the workspaces, redirect gorouter function will
/// kick in and land the user on CreateWorkspaceInitialScreen,
/// where he can again click on user profile button and delete
/// the account. In this case there is no workspaceId available
/// since this screen is above :workspaceId shell route - this
/// was taken into consideration in the UserProfileViewModel
/// (workspaceId is used only for displaying user role chip and
/// there is not point in displaying role chip on this screen
/// as it's not part of the :workspaceId shell route). Handling
/// of this case is prone to refactor in the future.
class UserProfileViewModel extends ChangeNotifier {
  UserProfileViewModel({
    required String? workspaceId,
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

  final String? _activeWorkspaceId;
  final UserRepository _userRepository;
  final SignOutUseCase _signOutUseCase;

  late Command0 loadUserDetails;
  late Command0 signOut;
  late Command0 deleteAccount;

  User? get details => _userRepository.user;

  WorkspaceRole? get currentWorkspaceRole => _activeWorkspaceId == null
      ? null
      : _userRepository.user?.roles
            .firstWhere((role) => role.workspaceId == _activeWorkspaceId)
            .role;

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
    final result = await _userRepository.deleteAccount();

    switch (result) {
      case Ok():
        await _signOutUseCase.forceLocalSignOut();
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
