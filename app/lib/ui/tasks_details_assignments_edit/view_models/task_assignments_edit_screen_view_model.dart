import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

import '../../../data/repositories/workspace/workspace_task/workspace_task_repository.dart';
import '../../../data/repositories/workspace/workspace_user/workspace_user_repository.dart';
import '../../../data/services/api/user/models/response/user_response.dart';
import '../../../data/services/api/workspace/progress_status.dart';
import '../../../domain/models/workspace_task.dart';
import '../../../domain/models/workspace_user.dart';
import '../../../utils/command.dart';

class TaskAssignmentsEditScreenViewModel extends ChangeNotifier {
  TaskAssignmentsEditScreenViewModel({
    required String workspaceId,
    required String taskId,
    required WorkspaceTaskRepository workspaceTaskRepository,
    required WorkspaceUserRepository workspaceUserRepository,
  }) : _activeWorkspaceId = workspaceId,
       _taskId = taskId,
       _workspaceTaskRepository = workspaceTaskRepository,
       _workspaceUserRepository = workspaceUserRepository {
    _loadWorkspaceTaskDetails();
    _workspaceUserRepository.addListener(_onWorkspaceUsersChanged);
    loadWorkspaceMembers = Command1(_loadWorkspaceMembers)
      ..execute(workspaceId);
    editTaskAssignments = Command1(_editTaskAssignments);
  }

  final String _activeWorkspaceId;
  final String _taskId;
  final WorkspaceTaskRepository _workspaceTaskRepository;
  final WorkspaceUserRepository _workspaceUserRepository;
  final _log = Logger('TaskAssignmentsEditScreenViewModel');

  late Command1<void, List<(String assigneeId, ProgressStatus status)>>
  editTaskAssignments;
  late Command1<void, String> loadWorkspaceMembers;

  String get activeWorkspaceId => _activeWorkspaceId;

  WorkspaceTask? _details;

  List<WorkspaceTaskAssignee>? get assignees => _details?.assignees;

  /// Represents workspace members other than those which
  /// are already assignees on this task.
  List<WorkspaceUser> get workspaceMembers =>
      _workspaceUserRepository.users
          ?.where(
            (user) =>
                _details != null &&
                user.role == WorkspaceRole.member &&
                _details!.assignees.none((assignee) => assignee.id == user.id),
          )
          .toList() ??
      [];

  void _onWorkspaceUsersChanged() {
    notifyListeners();
  }

  Result<void> _loadWorkspaceTaskDetails() {
    final result = _workspaceTaskRepository.loadWorkspaceTaskDetails(
      taskId: _taskId,
    );

    switch (result) {
      case Ok():
        _details = result.value;
        notifyListeners();
        return const Result.ok(null);
      case Error():
        _log.warning('Failed to load task details', result.error);
        return result;
    }
  }

  Future<Result<void>> _loadWorkspaceMembers(String workspaceId) async {
    final result = await _workspaceUserRepository.loadWorkspaceUsers(
      workspaceId: workspaceId,
    );

    switch (result) {
      case Ok():
        break;
      case Error():
        _log.warning('Failed to load workspace users', result.error);
    }

    return result;
  }

  Future<Result<void>> _editTaskAssignments(
    List<(String assigneeId, ProgressStatus status)> assignments,
  ) async {
    final result = await _workspaceTaskRepository.updateTaskAssignments(
      _activeWorkspaceId,
      _taskId,
      assignments,
    );

    switch (result) {
      case Ok():
        break;
      case Error():
        _log.warning('Failed to edit task assignments', result.error);
    }

    return result;
  }

  @override
  void dispose() {
    _workspaceUserRepository.removeListener(_onWorkspaceUsersChanged);
    super.dispose();
  }
}
