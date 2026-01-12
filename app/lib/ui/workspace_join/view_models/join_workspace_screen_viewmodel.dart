import 'package:flutter/foundation.dart';

import '../../../data/repositories/workspace/workspace_invite/workspace_invite_repository.dart';
import '../../../domain/models/workspace.dart';
import '../../../domain/use_cases/join_workspace_use_case.dart';
import '../../../utils/command.dart';

class JoinWorkspaceScreenViewmodel extends ChangeNotifier {
  JoinWorkspaceScreenViewmodel({
    required String inviteToken,
    required WorkspaceInviteRepository workspaceInviteRepository,
    required JoinWorkspaceUseCase joinWorkspaceUseCase,
  }) : _inviteToken = inviteToken,
       _workspaceInviteRepository = workspaceInviteRepository,
       _joinWorkspaceUseCase = joinWorkspaceUseCase {
    joinWorkspaceViaInviteLink = Command0(_joinWorkspaceViaInviteLink);
    fetchWorkspaceInfoByInviteToken = Command0(_fetchWorkspaceInfoByInviteToken)
      ..execute();
  }

  final String _inviteToken;
  final WorkspaceInviteRepository _workspaceInviteRepository;
  final JoinWorkspaceUseCase _joinWorkspaceUseCase;

  late Command0<String> joinWorkspaceViaInviteLink;
  late Command0 fetchWorkspaceInfoByInviteToken;

  Workspace? _workspaceInfo;

  Workspace? get workspaceInfo => _workspaceInfo;

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

  Future<Result<String>> _joinWorkspaceViaInviteLink() async {
    final result = await _joinWorkspaceUseCase.joinWorkspace(_inviteToken);

    switch (result) {
      case Ok<String>():
        return Result.ok(result.value);
      case Error<String>():
        return Result.error(result.error, result.stackTrace);
    }
  }
}
