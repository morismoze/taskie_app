import 'package:flutter/foundation.dart';

import '../../../data/repositories/user/user_repository.dart';
import '../../../data/repositories/workspace/workspace_invite/workspace_invite_repository.dart';
import '../../../data/services/api/api_response.dart';
import '../../../data/services/api/exceptions/general_api_exception.dart';
import '../../../domain/models/user.dart';
import '../../../domain/models/workspace.dart';
import '../../../domain/use_cases/active_workspace_change_use_case.dart';
import '../../../domain/use_cases/join_workspace_use_case.dart';
import '../../../utils/command.dart';

class JoinWorkspaceScreenViewmodel extends ChangeNotifier {
  JoinWorkspaceScreenViewmodel({
    required String inviteToken,
    required WorkspaceInviteRepository workspaceInviteRepository,
    required UserRepository userRepository,
    required JoinWorkspaceUseCase joinWorkspaceUseCase,
    required ActiveWorkspaceChangeUseCase activeWorkspaceChangeUseCase,
  }) : _inviteToken = inviteToken,
       _workspaceInviteRepository = workspaceInviteRepository,
       _userRepository = userRepository,
       _activeWorkspaceChangeUseCase = activeWorkspaceChangeUseCase,
       _joinWorkspaceUseCase = joinWorkspaceUseCase {
    _userRepository.addListener(_onUserChanged);
    joinWorkspaceViaInviteLink = Command0(_joinWorkspaceViaInviteLink);
    fetchWorkspaceInfoByInviteToken = Command0(_fetchWorkspaceInfoByInviteToken)
      ..execute();
    _loadUser();
  }

  final String _inviteToken;
  final WorkspaceInviteRepository _workspaceInviteRepository;
  final UserRepository _userRepository;
  final ActiveWorkspaceChangeUseCase _activeWorkspaceChangeUseCase;
  final JoinWorkspaceUseCase _joinWorkspaceUseCase;

  late Command0<String> joinWorkspaceViaInviteLink;
  late Command0 fetchWorkspaceInfoByInviteToken;

  User? get user => _userRepository.user;

  Workspace? _workspaceInfo;

  Workspace? get workspaceInfo => _workspaceInfo;

  void _onUserChanged() {
    notifyListeners();
  }

  Future<Result<void>> _fetchWorkspaceInfoByInviteToken() async {
    final result = await _workspaceInviteRepository
        .fetchWorkspaceInfoByInviteToken(inviteToken: _inviteToken);

    switch (result) {
      case Ok<Workspace>():
        _workspaceInfo = result.value;
        return const Result.ok(null);
      case Error<Workspace>():
        return Result.error(result.error, result.stackTrace);
    }
  }

  Future<Result<void>> _loadUser() async {
    final result = await firstOkOrLastError(_userRepository.loadUser());

    switch (result) {
      case Ok():
        return const Result.ok(null);
      case Error():
        return result;
    }
  }

  Future<Result<String>> _joinWorkspaceViaInviteLink() async {
    final result = await _joinWorkspaceUseCase.joinWorkspace(_inviteToken);

    switch (result) {
      case Ok<String>():
        return Result.ok(result.value);
      case Error<String>():
        if (result.error case GeneralApiException(
          error: final apiError,
        ) when apiError.code == ApiErrorCode.workspaceInviteExistingUser) {
          // We invoke workspace change in the join workspace use case but only
          // on the success. Here we also want to invoke it on failure for
          // the case when user already is part of the workspace, because
          // in a JoinWorkspaceScreen listener we redirect user to that workspace
          // when this error is triggered.
          await _activeWorkspaceChangeUseCase.handleWorkspaceChange(
            _workspaceInfo!.id,
          );
        }
        return Result.error(result.error, result.stackTrace);
    }
  }

  @override
  void dispose() {
    _userRepository.removeListener(_onUserChanged);
    super.dispose();
  }
}
