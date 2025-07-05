import 'package:logging/logging.dart';

import '../../../data/repositories/workspace/workspace_repository.dart';

class WorkspaceSettingsViewmodel {
  WorkspaceSettingsViewmodel({required WorkspaceRepository workspaceRepository})
    : _workspaceRepository = workspaceRepository;

  final WorkspaceRepository _workspaceRepository;
  final _log = Logger('WorkspaceSettingsViewmodel');
}
