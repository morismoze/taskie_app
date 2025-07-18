import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

import '../../../data/repositories/workspace/workspace_user/workspace_user_repository.dart';
import '../../../domain/models/workspace_user.dart';
import '../../../utils/command.dart';

class WorkspaceUserDetailsScreenViewModel extends ChangeNotifier {
  WorkspaceUserDetailsScreenViewModel({
    required String workspaceId,
    required String workspaceUserId,
    required WorkspaceUserRepository workspaceUserRepository,
  }) : _activeWorkspaceId = workspaceId,
       _workspaceUserId = workspaceUserId,
       _workspaceUserRepository = workspaceUserRepository {
    loadWorkspaceUserDetails = Command1(_loadWorkspaceUserDetails)
      ..execute((workspaceId, workspaceUserId));
  }

  final String _activeWorkspaceId;
  final String _workspaceUserId;
  final WorkspaceUserRepository _workspaceUserRepository;
  final _log = Logger('WorkspaceUserDetailsScreenViewModel');

  late Command1<void, (String, String)> loadWorkspaceUserDetails;

  String get activeWorkspaceId => _activeWorkspaceId;

  WorkspaceUser? _details;

  WorkspaceUser? get details => _details;

  Future<Result<void>> _loadWorkspaceUserDetails(
    (String workspaceId, String workspaceUserId) details,
  ) async {
    final (workspaceId, workspaceUserId) = details;
    final result = _workspaceUserRepository.loadWorkspaceUserDetails(
      workspaceId: workspaceId,
      workspaceUserId: workspaceUserId,
    );

    switch (result) {
      case Ok():
        _details = result.value;
        return result;
      case Error():
        _log.warning('Failed to load workspace user details', result.error);
        return result;
    }
  }
}
