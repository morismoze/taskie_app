import 'package:flutter/material.dart';

import '../../../../domain/models/filter.dart';
import '../../../../domain/models/paginable.dart';
import '../../../../domain/models/workspace_goal.dart';
import '../../../../utils/command.dart';
import '../../../services/api/value_patch.dart';

abstract class WorkspaceGoalRepository extends ChangeNotifier {
  bool get isFilterSearch;

  ObjectiveFilter get activeFilter;

  Paginable<WorkspaceGoal>? get goals;

  Stream<Result<void>> loadGoals({
    required String workspaceId,
    bool forceFetch,
    ObjectiveFilter? filter,
  });

  Future<Result<void>> createGoal(
    String workspaceId, {
    required String title,
    required String assignee,
    required int requiredPoints,
    String? description,
  });

  Result<WorkspaceGoal> loadGoalDetails({required String goalId});

  Future<Result<void>> updateGoalDetails(
    String workspaceId,
    String goalId, {
    ValuePatch<String>? title,
    ValuePatch<String?>? description,
    ValuePatch<String>? assigneeId,
    ValuePatch<int>? requiredPoints,
  });

  Future<Result<void>> closeGoal({
    required String workspaceId,
    required String goalId,
  });

  Future<void> purgeGoalsCache();
}
