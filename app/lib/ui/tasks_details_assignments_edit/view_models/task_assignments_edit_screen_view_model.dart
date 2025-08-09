import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

import '../../../data/repositories/workspace/workspace_task/workspace_task_repository.dart';
import '../../../data/repositories/workspace/workspace_user/workspace_user_repository.dart';
import '../../../data/services/api/user/models/response/user_response.dart';
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
    editTaskDetails = Command1(_editTaskAssignments);
    addNewAssignees = Command1(_addNewAssignees);
  }

  final String _activeWorkspaceId;
  final String _taskId;
  final WorkspaceTaskRepository _workspaceTaskRepository;
  final WorkspaceUserRepository _workspaceUserRepository;
  final _log = Logger('TaskAssignmentsEditScreenViewModel');

  late Command1<
    void,
    (String? title, String? description, int? rewardPoints, DateTime? dueDate)
  >
  editTaskDetails;
  late Command1<void, List<String>> addNewAssignees;
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
    (String? title, String? description, int? rewardPoints, DateTime? dueDate)
    details,
  ) async {
    return const Result.ok(null);
  }

  Future<Result<void>> _addNewAssignees(List<String> assigneeIds) async {
    return const Result.ok(null);
  }

  @override
  void dispose() {
    _workspaceUserRepository.removeListener(_onWorkspaceUsersChanged);
    super.dispose();
  }
}
