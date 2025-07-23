import 'package:flutter/material.dart';

import '../../../../domain/models/workspace_goal.dart';
import '../../../../utils/command.dart';
import '../../../services/api/workspace/paginable_objectives.dart';

/// This is a [ChangeNotifier] beacuse of 2 reasons:
///
/// 1. when creating new goals, those goals are pushed into the
/// current cached list of goals,
///
/// 2. when user does pull-to-refresh, cached list of goals
/// will be updated
abstract class WorkspaceGoalRepository extends ChangeNotifier {
  List<WorkspaceGoal>? get goals;

  Future<Result<void>> loadGoals({
    required String workspaceId,
    required PaginableObjectivesRequestQueryParams paginable,
    bool forceFetch,
  });

  Future<Result<void>> createGoal(
    String workspaceId, {
    required String title,
    required String assignee,
    required int requiredPoints,
    String? description,
  });

  void purgeGoalsCache();
}
