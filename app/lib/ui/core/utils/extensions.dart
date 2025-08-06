import 'package:flutter/widgets.dart';

import '../../../data/services/api/paginable.dart';
import '../../../data/services/api/user/models/response/user_response.dart';
import '../../../data/services/api/workspace/progress_status.dart';
import '../l10n/l10n_extensions.dart';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }

  String? get nullIfEmpty => isEmpty ? null : this;
}

extension WorkspaceRoleLocalization on WorkspaceRole {
  String l10n(BuildContext context) {
    switch (this) {
      case WorkspaceRole.manager:
        return context.localization.misc_roleManager;
      case WorkspaceRole.member:
        return context.localization.misc_roleMember;
    }
  }
}

extension ProgressStatusLocalization on ProgressStatus {
  String l10n(BuildContext context) => switch (this) {
    ProgressStatus.inProgress => context.localization.progressStatusInProgress,
    ProgressStatus.completed => context.localization.progressStatusCompleted,
    ProgressStatus.completedAsStale =>
      context.localization.progressStatusCompletedAsStale,
    ProgressStatus.closed => context.localization.progressStatusClosed,
  };
}

extension SortByLocalisation on SortBy {
  String l10n(BuildContext context) {
    switch (this) {
      case SortBy.newestFirst:
        return context.localization.sortByNewest;
      case SortBy.oldestFirst:
        return context.localization.sortByOldest;
    }
  }
}
