import 'package:logging/logging.dart';

import '../../../data/repositories/user/user_repository.dart';
import '../../../data/repositories/workspace/workspace/workspace_repository.dart';
import '../../../utils/command.dart';

class EntryScreenViewModel {
  EntryScreenViewModel({
    required UserRepository userRepository,
    required WorkspaceRepository workspaceRepository,
  }) : _userRepository = userRepository,
       _workspaceRepository = workspaceRepository {
    loadInitial = Command0(_loadInitial)..execute();
  }

  final UserRepository _userRepository;
  final WorkspaceRepository _workspaceRepository;
  final _log = Logger('EntryViewModel');

  /// Initial load of needed data.
  ///
  /// Returns workspaceId of the workspace to navigate to or null
  /// if the loaded workspaces list is empty.
  late Command0 loadInitial;

  Future<Result<String?>> _loadInitial() async {
    final resultLoadUser = await _userRepository.loadUser();

    switch (resultLoadUser) {
      case Ok():
        break;
      case Error():
        _log.warning('Failed to load user', resultLoadUser.error);
        return Result.error(Exception(resultLoadUser.error));
    }

    // getWorkspaces repository function implementation also
    // notifies when there is zero workspaces fetched from origin.
    final resultLoadWorkspaces = await _workspaceRepository.loadWorkspaces();

    switch (resultLoadWorkspaces) {
      case Ok():
        if (resultLoadWorkspaces.value.isEmpty) {
          // Return null in the case workspaces list is empty, because
          // gorouter redirect function will kick in automatically in this case
          // because of the comment above, and will redirect the user to
          // workspaces/create/initial screen.
          return const Result.ok(null);
        }
        break;
      case Error():
        _log.warning('Failed to load workspaces', resultLoadWorkspaces.error);
        return Result.error(Exception(resultLoadWorkspaces.error));
    }

    final activeWorkspaceIdResult = await _workspaceRepository
        .loadActiveWorkspaceId();

    if (activeWorkspaceIdResult is Error<String?>) {
      _log.warning(
        'Failed to get active workspace ID',
        activeWorkspaceIdResult.error,
      );
      return Result.error(Exception(activeWorkspaceIdResult.error));
    }

    final activeWorkspaceId = (activeWorkspaceIdResult as Ok<String?>).value;
    if (activeWorkspaceId != null) {
      return Result.ok(activeWorkspaceIdResult.value);
    } else {
      // User has either:
      // 1. created his first workspace so we will set active workspace ID to that workspace ID or
      // 2. deleted application storage
      final firstWorkspaceId = resultLoadWorkspaces.value.first.id;
      final resultSetActiveWorkspaceId = await _workspaceRepository
          .setActiveWorkspaceId(firstWorkspaceId);

      switch (resultSetActiveWorkspaceId) {
        case Ok():
          return Result.ok(firstWorkspaceId);
        case Error():
          _log.warning(
            'Failed to load workspaces',
            resultSetActiveWorkspaceId.error,
          );
          return Result.error(Exception(resultSetActiveWorkspaceId.error));
      }
    }
  }
}
