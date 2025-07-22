import 'package:logging/logging.dart';

import '../../../data/repositories/workspace/workspace/workspace_repository.dart';

class CreateGoalScreenViewmodel {
  CreateGoalScreenViewmodel({required WorkspaceRepository workspaceRepository})
    : _workspaceRepository = workspaceRepository;

  final WorkspaceRepository _workspaceRepository;
  final _log = Logger('CreateGoalScreenViewmodel');
}
