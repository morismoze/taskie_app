import 'package:flutter/foundation.dart';

import '../../../../data/repositories/user/user_repository.dart';
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

/// Close dialog and bottom sheet - active workspace ID was not
/// the same as the workspace ID which was left.
class LeaveWorkspaceResultCloseOverlays extends LeaveWorkspaceResult {
  const LeaveWorkspaceResultCloseOverlays();
}

/// Close dialog and bottom sheet and navigate to the first workspace
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
    required UserRepository userRepository,
  }) : _activeWorkspaceId = workspaceId,
       _workspaceRepository = workspaceRepository,
       _userRepository = userRepository,
       _refreshTokenUseCase = refreshTokenUseCase,
       _activeWorkspaceChangeUseCase = activeWorkspaceChangeUseCase {
    _workspaceRepository.addListener(_onWorkspacesChanged);
    loadWorkspaces = Command0(_loadWorkspaces);
    leaveWorkspace = Command1(_leaveWorkspace);
    changeActiveWorkspace = Command1(_changeActiveWorkspace);
  }

  final String _activeWorkspaceId;
  final WorkspaceRepository _workspaceRepository;
  final UserRepository _userRepository;
  final RefreshTokenUseCase _refreshTokenUseCase;
  final ActiveWorkspaceChangeUseCase _activeWorkspaceChangeUseCase;

  late Command0 loadWorkspaces;

  /// Returns ID of the workspace which was left or null
  /// if the updated workspaces list is empty.
  late Command1<LeaveWorkspaceResult, String> leaveWorkspace;
  late Command1<String, String> changeActiveWorkspace;

  String get activeWorkspaceId => _activeWorkspaceId;

  List<Workspace> get workspaces {
    final workspaces = _workspaceRepository.workspaces;

    if (workspaces == null) {
      return [];
    }

    final sortedWorkspaces = List<Workspace>.from(workspaces);
    sortedWorkspaces.sort((w1, w2) {
      // Check if workspace is the active one - if it is
      // push it first
      if (w1.id == _activeWorkspaceId) {
        return -1;
      }

      if (w2.id == _activeWorkspaceId) {
        return 1;
      }

      // Second sort by workspace names ASC
      return w1.name.compareTo(w2.name);
    });

    return sortedWorkspaces;
  }

  String? _inviteLink;

  String? get inviteLink => _inviteLink;

  void _onWorkspacesChanged() {
    notifyListeners();
  }

  Future<Result<List<Workspace>>> _loadWorkspaces() async {
    final result = await _workspaceRepository.loadWorkspaces();

    switch (result) {
      case Ok():
        break;
      case Error():
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
        return Result.error(resultLeave.error);
    }

    // We need to refresh the access token since we keep list of roles with
    // corresponding workspaces inside the access token.
    final resultRefresh = await _refreshTokenUseCase.refreshAcessToken();

    switch (resultRefresh) {
      case Ok():
        break;
      case Error():
        return Result.error(resultRefresh.error);
    }

    // We need to load workspaces again - this will load from repository cache, which was updated with the
    // given workspace by removing it from that cache list in WorkspaceRepository.leaveWorkspace function.
    final resultLoad = await _loadWorkspaces();

    switch (resultLoad) {
      case Ok():
        final updatedWorkspacesList = resultLoad.value;
        // CASE 1 - there are no more workspaces left
        if (updatedWorkspacesList.isEmpty) {
          // We need to refresh the access token since we keep list of roles with
          // corresponding workspaces in the user as well.
          final resultUser = await _userRepository.loadUser(forceFetch: true);

          switch (resultUser) {
            case Ok():
              break;
            case Error():
              return Result.error(resultUser.error);
          }

          // Return null in the case workspaces list is now empty, because
          // gorouter redirect function will kick in automatically in this case
          // and will redirect the user to workspaces/create/initial screen, so
          // we don't need to do navigation in the AppDrawer listener function.
          return const Result.ok(LeaveWorkspaceResultNoAction());
        }

        // CASE 2 - we need to decide if the user has to navigate to another workspace.
        // And that is defined by the fact if the user has left the current active workspace.
        if (_activeWorkspaceId == leavingWorkspaceId) {
          // No need for user refresh here as that action already triggers inside ActiveWorkspaceChangeUseCase.
          //
          // If the current active workspace ID is equal to the workspace ID
          // user just left, then we navigate to the workspace ID taken from
          // the first workspace in the workspaces list.
          final newActiveWorkspaceId = updatedWorkspacesList.first.id;
          await _changeActiveWorkspace(newActiveWorkspaceId);
          return Result.ok(
            LeaveWorkspaceResultNavigateTo(newActiveWorkspaceId),
          );
        }

        // CASE 3 - non-active workspace was left, just close the overlays

        // We need to refresh the access token since we keep list of roles with
        // corresponding workspaces in the user as well.
        final resultUser = await _userRepository.loadUser(forceFetch: true);

        switch (resultUser) {
          case Ok():
            break;
          case Error():
            return Result.error(resultUser.error);
        }

        return const Result.ok(LeaveWorkspaceResultCloseOverlays());
      case Error():
        return Result.error(resultLoad.error);
    }
  }

  @override
  void dispose() {
    _workspaceRepository.removeListener(_onWorkspacesChanged);
    super.dispose();
  }
}
