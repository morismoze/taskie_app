import 'package:flutter/material.dart';

import '../../../data/services/api/paginable.dart';
import '../../../data/services/api/user/models/response/user_response.dart';
import '../../../data/services/api/workspace/progress_status.dart';
import '../l10n/l10n_extensions.dart';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }

  String? get nullIfEmpty => isEmpty ? null : this;

  Widget format({required TextStyle style, TextAlign? textAlign}) {
    // ** is parsed as bold
    // __ (double underscore) is parsed as underline
    // * is parsed as italic
    final regex = RegExp(r'\*\*(.*?)\*\*|__(.*?)__|(?<!\*)\*(.*?)\*(?!\*)');
    final matches = regex.allMatches(this);

    if (matches.isEmpty) {
      return Text(this, textAlign: textAlign, style: style);
    }

    final spans = <TextSpan>[];
    var lastIndex = 0;

    for (final match in matches) {
      // Add text before match
      if (match.start > lastIndex) {
        spans.add(
          TextSpan(text: substring(lastIndex, match.start), style: style),
        );
      }

      final boldText = match.group(1);
      final underlineText = match.group(2);
      final italicText = match.group(3);

      if (boldText != null) {
        spans.add(
          TextSpan(
            text: boldText,
            style: style.copyWith(fontWeight: FontWeight.bold),
          ),
        );
      } else if (underlineText != null) {
        spans.add(
          TextSpan(
            text: underlineText,
            style: style.copyWith(decoration: TextDecoration.underline),
          ),
        );
      } else if (italicText != null) {
        spans.add(
          TextSpan(
            text: italicText,
            style: style.copyWith(fontStyle: FontStyle.italic),
          ),
        );
      }

      lastIndex = match.end;
    }

    // Add remaining text
    if (lastIndex < length) {
      spans.add(TextSpan(text: substring(lastIndex), style: style));
    }

    return Text.rich(TextSpan(children: spans), textAlign: textAlign);
  }
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
    ProgressStatus.notCompleted =>
      context.localization.progressStatusNotCompleted,
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

extension ColorBrightness on Color {
  Color lighten([double amount = 0.85]) {
    assert(amount >= 0 && amount <= 1);
    return Color.lerp(this, Colors.white, amount)!;
  }
}
