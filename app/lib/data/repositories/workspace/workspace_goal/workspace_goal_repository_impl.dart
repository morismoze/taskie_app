import 'package:logging/logging.dart';

import '../../../../domain/models/assignee.dart';
import '../../../../domain/models/workspace_goal.dart';
import '../../../../utils/command.dart';
import '../../../services/api/paginable.dart';
import '../../../services/api/workspace/paginable_objectives.dart';
import '../../../services/api/workspace/workspace_goal/models/request/create_goal_request.dart';
import '../../../services/api/workspace/workspace_goal/models/response/workspace_goal_response.dart';
import '../../../services/api/workspace/workspace_goal/workspace_goal_api_service.dart';
import 'workspace_goal_repository.dart';

class WorkspaceGoalRepositoryImpl extends WorkspaceGoalRepository {
  WorkspaceGoalRepositoryImpl({
    required WorkspaceGoalApiService workspaceGoalApiService,
  }) : _workspaceGoalApiService = workspaceGoalApiService;

  final WorkspaceGoalApiService _workspaceGoalApiService;

  final _log = Logger('WorkspaceGoalRepository');

  List<WorkspaceGoal>? _cachedGoals;

  @override
  List<WorkspaceGoal>? get goals => _cachedGoals;

  @override
  Future<Result<void>> loadGoals({
    required String workspaceId,
    required ObjectiveRequestQueryParams paginable,
    bool forceFetch = false,
  }) async {
    if (!forceFetch && _cachedGoals != null) {
      return const Result.ok(null);
    }

    try {
      final result = await _workspaceGoalApiService.getGoals(
        workspaceId: workspaceId,
        paginable: paginable,
      );
      switch (result) {
        case Ok<PaginableResponse<WorkspaceGoalResponse>>():
          final mappedData = result.value.items
              .map(
                (goal) => WorkspaceGoal(
                  id: goal.id,
                  title: goal.title,
                  requiredPoints: goal.requiredPoints,
                  assignee: Assignee(
                    id: goal.assignee.id,
                    firstName: goal.assignee.firstName,
                    lastName: goal.assignee.lastName,
                    profileImageUrl: goal.assignee.profileImageUrl,
                  ),
                  status: goal.status,
                  description: goal.description,
                ),
              )
              .toList();

          _cachedGoals = mappedData;
          notifyListeners();

          return const Result.ok(null);
        case Error<PaginableResponse<WorkspaceGoalResponse>>():
          return Result.error(result.error);
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<void>> createGoal(
    String workspaceId, {
    required String title,
    required String assignee,
    required int requiredPoints,
    String? description,
  }) async {
    try {
      final payload = CreateGoalRequest(
        title: title,
        assignee: assignee,
        requiredPoints: requiredPoints,
        description: description,
      );
      final result = await _workspaceGoalApiService.createGoal(
        workspaceId: workspaceId,
        payload: payload,
      );

      switch (result) {
        case Ok<WorkspaceGoalResponse>():
          final newGoalResultValue = result.value;
          final newGoal = WorkspaceGoal(
            id: newGoalResultValue.id,
            title: newGoalResultValue.title,
            requiredPoints: newGoalResultValue.requiredPoints,
            assignee: Assignee(
              id: newGoalResultValue.assignee.id,
              firstName: newGoalResultValue.assignee.firstName,
              lastName: newGoalResultValue.assignee.lastName,
              profileImageUrl: newGoalResultValue.assignee.profileImageUrl,
            ),
            status: newGoalResultValue.status,
            description: newGoalResultValue.description,
            isNew: true,
          );

          // Add the new goal with the `new` flag to the start index, so additional
          // UI styles are applied to it in the current goals paginable page
          if (_cachedGoals != null) {
            _cachedGoals!.insert(0, newGoal);
            notifyListeners();
          }

          return const Result.ok(null);
        case Error<WorkspaceGoalResponse>():
          return Result.error(result.error);
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  @override
  void purgeGoalsCache() {
    _cachedGoals = null;
  }
}
