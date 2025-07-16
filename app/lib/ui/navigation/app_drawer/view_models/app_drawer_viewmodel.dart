import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

import '../../../../data/repositories/workspace/workspace/workspace_repository.dart';
import '../../../../domain/models/workspace.dart';
import '../../../../domain/use_cases/active_workspace_change_use_case.dart';
import '../../../../domain/use_cases/refresh_token_use_case.dart';
import '../../../../utils/command.dart';

sealed class LeaveWorkspaceResult {
  const LeaveWorkspaceResult();
}

/// Do nothing, gorouter redirect will kick in - user
/// has left the last workspace.
class LeaveWorkspaceResultNoAction extends LeaveWorkspaceResult {
  const LeaveWorkspaceResultNoAction();
}

/// Close modal and bottom sheet - active workspace ID was not
/// the same as the workspace ID which was left.
class LeaveWorkspaceResultCloseOverlays extends LeaveWorkspaceResult {
  const LeaveWorkspaceResultCloseOverlays();
}

/// Close modal and bottom sheet and navigate to the first workspace
/// from the updated workspaces list - active workspace ID was the
/// same as the workspace ID which was left.
class LeaveWorkspaceResultNavigateTo extends LeaveWorkspaceResult {
  const LeaveWorkspaceResultNavigateTo(this.workspaceId);

  final String workspaceId;
}

class AppDrawerViewModel extends ChangeNotifier {
  AppDrawerViewModel({
    required String workspaceId,
    required WorkspaceRepository workspaceRepository,
    required RefreshTokenUseCase refreshTokenUseCase,
    required ActiveWorkspaceChangeUseCase activeWorkspaceChangeUseCase,
  }) : _activeWorkspaceId = workspaceId,
       _workspaceRepository = workspaceRepository,
       _refreshTokenUseCase = refreshTokenUseCase,
       _activeWorkspaceChangeUseCase = activeWorkspaceChangeUseCase {
    loadWorkspaces = Command0(_loadWorkspaces);
    leaveWorkspace = Command1(_leaveWorkspace);
    changeActiveWorkspace = Command1(_changeActiveWorkspace);
  }

  final String _activeWorkspaceId;
  final WorkspaceRepository _workspaceRepository;
  final RefreshTokenUseCase _refreshTokenUseCase;
  final ActiveWorkspaceChangeUseCase _activeWorkspaceChangeUseCase;
  final _log = Logger('AppDrawerViewModel');

  late Command0 loadWorkspaces;

  /// Returns ID of the workspace which was left or null
  /// if the updated workspaces list is empty.
  late Command1<LeaveWorkspaceResult, String> leaveWorkspace;
  late Command1<String, String> changeActiveWorkspace;

  String get activeWorkspaceId => _activeWorkspaceId;

  List<Workspace> _workspaces = [];

  List<Workspace> get workspaces => _workspaces;

  String? _inviteLink;

  String? get inviteLink => _inviteLink;

  Future<Result<List<Workspace>>> _loadWorkspaces() async {
    final result = await _workspaceRepository.loadWorkspaces();

    switch (result) {
      case Ok():
        _workspaces = result.value;
        notifyListeners();
      case Error():
        _log.warning('Failed to load workspaces', result.error);
    }

    return result;
  }

  Future<Result<String>> _changeActiveWorkspace(String workspaceId) async {
    final result = await _activeWorkspaceChangeUseCase.handleWorkspaceChange(
      workspaceId,
    );

    switch (result) {
      case Ok():
        return Result.ok(workspaceId);
      case Error():
        _log.warning('Failed to change active workspace', result.error);
        return Result.error(result.error);
    }
  }

  Future<Result<LeaveWorkspaceResult>> _leaveWorkspace(
    String leavingWorkspaceId,
  ) async {
    final resultLeave = await _workspaceRepository.leaveWorkspace(
      workspaceId: leavingWorkspaceId,
    );

    switch (resultLeave) {
      case Ok():
        break;
      case Error():
        _log.warning('Failed to leave the workspace', resultLeave.error);
        return Result.error(resultLeave.error);
    }

    // We need to refresh the access token since we keep list of roles with
    // corresponding workspaces inside the access token.
    final resultRefresh = await _refreshTokenUseCase.refreshAcessToken();

    switch (resultRefresh) {
      case Ok():
        break;
      case Error():
        _log.warning('Failed to refresh token', resultRefresh.error);
        return Result.error(resultRefresh.error);
    }

    // We need to load workspaces again - this will load from repository cache, which was updated with the
    // given workspace by removing it from that cache list in WorkspaceRepository.leaveWorkspace function.
    final resultLoad = await _loadWorkspaces();

    switch (resultLoad) {
      case Ok():
        final updatedWorkspacesList = resultLoad.value;
        // CASE 1
        if (updatedWorkspacesList.isEmpty) {
          // Return null in the case workspaces list is now empty, because
          // gorouter redirect function will kick in automatically in this case
          // and will redirect the user to workspaces/create/initial screen, so
          // we don't need to do navigation in AppDrawer listener function.
          return const Result.ok(LeaveWorkspaceResultNoAction());
        }

        // CASE 2 - we need to decide if the user has to navigate to another workspace.
        // And that is defined by the fact if the user has left the current active workspace.
        if (_activeWorkspaceId == leavingWorkspaceId) {
          // CASE 2.a)
          // If the current active workspace ID is equal to the workspace ID
          // user just left, then we navigate to the workspace ID taken from
          // the first workspace in the workspaces list.
          final newActiveWorkspaceId = updatedWorkspacesList.first.id;
          await _changeActiveWorkspace(newActiveWorkspaceId);
          return Result.ok(
            LeaveWorkspaceResultNavigateTo(newActiveWorkspaceId),
          );
        }

        return const Result.ok(LeaveWorkspaceResultCloseOverlays());
      case Error():
        _log.warning('Failed to load workspaces', resultLoad.error);
        return Result.error(resultLoad.error);
    }
  }
}
