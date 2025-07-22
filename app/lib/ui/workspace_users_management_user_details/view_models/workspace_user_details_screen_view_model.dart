import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

import '../../../data/repositories/user/user_repository.dart';
import '../../../data/repositories/workspace/workspace_user/workspace_user_repository.dart';
import '../../../domain/models/user.dart';
import '../../../domain/models/workspace_user.dart';
import '../../../utils/command.dart';

class WorkspaceUserDetailsScreenViewModel extends ChangeNotifier {
  WorkspaceUserDetailsScreenViewModel({
    required String workspaceId,
    required String workspaceUserId,
    required UserRepository userRepository,
    required WorkspaceUserRepository workspaceUserRepository,
  }) : _activeWorkspaceId = workspaceId,
       _workspaceUserId = workspaceUserId,
       _userRepository = userRepository,
       _workspaceUserRepository = workspaceUserRepository {
    loadWorkspaceUserDetails(
      workspaceId: workspaceId,
      workspaceUserId: workspaceUserId,
    );
  }

  final String _activeWorkspaceId;
  final String _workspaceUserId;
  final UserRepository _userRepository;
  final WorkspaceUserRepository _workspaceUserRepository;
  final _log = Logger('WorkspaceUserDetailsScreenViewModel');

  String get activeWorkspaceId => _activeWorkspaceId;

  User get currentUser => _userRepository.user!;

  WorkspaceUser? _details;

  WorkspaceUser? get details => _details;

  Result<void> loadWorkspaceUserDetails({
    required String workspaceId,
    required String workspaceUserId,
  }) {
    final result = _workspaceUserRepository.loadWorkspaceUserDetails(
      workspaceId: workspaceId,
      workspaceUserId: workspaceUserId,
    );

    switch (result) {
      case Ok():
        _details = result.value;
        notifyListeners();
        return const Result.ok(null);
      case Error():
        _log.warning('Failed to load workspace user details', result.error);
        return result;
    }
  }
}
