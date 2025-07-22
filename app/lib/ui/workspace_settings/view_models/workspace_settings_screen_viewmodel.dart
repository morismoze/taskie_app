import 'package:logging/logging.dart';

import '../../../data/repositories/workspace/workspace/workspace_repository.dart';

class WorkspaceSettingsScreenViewmodel {
  WorkspaceSettingsScreenViewmodel({
    required String workspaceId,
    required WorkspaceRepository workspaceRepository,
  }) : _activeWorkspaceId = workspaceId,
       _workspaceRepository = workspaceRepository;

  final String _activeWorkspaceId;
  final WorkspaceRepository _workspaceRepository;
  final _log = Logger('WorkspaceSettingsScreenViewmodel');
}
