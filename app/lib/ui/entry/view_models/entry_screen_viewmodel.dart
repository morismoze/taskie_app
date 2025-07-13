import 'package:logging/logging.dart';

import '../../../data/repositories/workspace/workspace/workspace_repository.dart';
import '../../../utils/command.dart';

class EntryScreenViewModel {
  EntryScreenViewModel({required WorkspaceRepository workspaceRepository})
    : _workspaceRepository = workspaceRepository {
    loadWorkspaces = Command0(_loadWorkspaces)..execute();
  }

  final WorkspaceRepository _workspaceRepository;
  final _log = Logger('EntryViewModel');

  late Command0 loadWorkspaces;

  Future<Result<String?>> _loadWorkspaces() async {
    final resultLoadWorkspaces = await _workspaceRepository.getWorkspaces();

    switch (resultLoadWorkspaces) {
      case Ok():
        break;
      case Error():
        _log.warning('Failed to load workspaces', resultLoadWorkspaces.error);
        return Result.error(Exception(resultLoadWorkspaces.error));
    }

    final activeWorkspaceIdResult = await _workspaceRepository
        .getActiveWorkspaceId();

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
      // User has created his first workspace so we will
      // set active workspace ID to that workspace ID.
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
