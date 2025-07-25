import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

import '../../../data/repositories/workspace/workspace/workspace_repository.dart';
import '../../../domain/models/workspace.dart';
import '../../../utils/command.dart';

class WorkspaceSettingsEditScreenViewModel extends ChangeNotifier {
  WorkspaceSettingsEditScreenViewModel({
    required String workspaceId,
    required WorkspaceRepository workspaceRepository,
  }) : _activeWorkspaceId = workspaceId,
       _workspaceRepository = workspaceRepository {
    _loadWorkspaceDetails();
    editWorkspaceDetails = Command1(_editWorkspaceDetails);
  }

  final String _activeWorkspaceId;
  final WorkspaceRepository _workspaceRepository;
  final _log = Logger('WorkspaceSettingsEditScreenViewModel');

  late Command1<void, (String? name, String? description)> editWorkspaceDetails;

  String get activeWorkspaceId => _activeWorkspaceId;

  Workspace? _details;

  Workspace? get details => _details;

  void _loadWorkspaceDetails() {
    final activeWorkspaceDetailsResult = _workspaceRepository
        .loadWorkspaceDetails(_activeWorkspaceId);

    switch (activeWorkspaceDetailsResult) {
      case Ok():
        _details = activeWorkspaceDetailsResult.value;
        return;
      case Error():
        _log.warning(
          'Failed to load workspace details',
          activeWorkspaceDetailsResult.error,
        );
    }
  }

  Future<Result<void>> _editWorkspaceDetails(
    (String? name, String? description) details,
  ) async {
    final (String? name, String? description) = details;
    final result = await _workspaceRepository.updateWorkspaceDetails(
      _activeWorkspaceId,
      name: name,
      description: description,
    );

    switch (result) {
      case Ok():
        return const Result.ok(null);
      case Error():
        _log.warning('Failed to update workspace details', result.error);
        return result;
    }
  }
}
