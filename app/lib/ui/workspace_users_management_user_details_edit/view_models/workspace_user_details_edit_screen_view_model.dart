import 'package:flutter/foundation.dart';

import '../../../data/repositories/workspace/workspace_user/workspace_user_repository.dart';
import '../../../data/services/api/user/models/response/user_response.dart';
import '../../../domain/models/workspace_user.dart';
import '../../../utils/command.dart';

class WorkspaceUserDetailsEditScreenViewModel extends ChangeNotifier {
  WorkspaceUserDetailsEditScreenViewModel({
    required String workspaceId,
    required String workspaceUserId,
    required WorkspaceUserRepository workspaceUserRepository,
  }) : _activeWorkspaceId = workspaceId,
       _workspaceUserId = workspaceUserId,
       _workspaceUserRepository = workspaceUserRepository {
    // This is not wrapped into a command since it is a
    // synchronous read from the repo cached list.
    loadWorkspaceUserDetails(
      workspaceId: workspaceId,
      workspaceUserId: workspaceUserId,
    );
    editWorkspaceUserDetails = Command1(_editWorkspaceUserDetails);
  }

  final String _activeWorkspaceId;
  final String _workspaceUserId;
  final WorkspaceUserRepository _workspaceUserRepository;

  late Command1<
    void,
    (String? firstName, String? lastName, WorkspaceRole? role)
  >
  editWorkspaceUserDetails;

  String get activeWorkspaceId => _activeWorkspaceId;

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
        return result;
    }
  }

  Future<Result<void>> _editWorkspaceUserDetails(
    (String? firstName, String? lastName, WorkspaceRole? role) details,
  ) async {
    final (String? firstName, String? lastName, WorkspaceRole? role) = details;

    // Don't invoke API request if the data stayed the same
    if (firstName == _details!.firstName &&
        lastName == _details!.lastName &&
        role == _details!.role) {
      return const Result.ok(null);
    }

    final result = await _workspaceUserRepository.updateWorkspaceUserDetails(
      workspaceId: _activeWorkspaceId,
      workspaceUserId: _workspaceUserId,
      firstName: firstName,
      lastName: lastName,
      role: role,
    );

    switch (result) {
      case Ok():
        return const Result.ok(null);
      case Error():
        return result;
    }
  }
}
