import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../../../domain/models/workspace_task.dart';
import '../../../core/theme/colors.dart';
import '../../../core/ui/app_avatar.dart';
import 'unassigned_label.dart';

/// Defines how many avatars will be shown before overflow avatar.
const _kShownAvatarsNumbers = 3;

class TaskAssignees extends StatelessWidget {
  const TaskAssignees({super.key, required this.assignees});

  final List<WorkspaceTaskAssignee> assignees;

  @override
  Widget build(BuildContext context) {
    if (assignees.isEmpty) {
      return const UnassignedLabel();
    }

    final shownAssignees = assignees.take(_kShownAvatarsNumbers);
    // How much each avatar will overlap with each other
    const overlap = kAppAvatarDefaultSize / 2;
    // Total width
    final totalWidth =
        (assignees.length * (kAppAvatarDefaultSize - overlap)) + overlap;

    return SizedBox(
      width: totalWidth,
      height: kAppAvatarDefaultSize,
      child: Stack(
        children: [
          ...shownAssignees.mapIndexed((index, assignee) {
            return Positioned(
              left: (index * (kAppAvatarDefaultSize - overlap)).toDouble(),
              child: AppAvatar(
                hashString: assignee.id,
                firstName: assignee.firstName,
                imageUrl: assignee.profileImageUrl,
              ),
            );
          }),
          if (assignees.length > 3)
            Positioned(
              left: (_kShownAvatarsNumbers * (kAppAvatarDefaultSize - overlap))
                  .toDouble(),
              child: _OverflowAvatar(totalAssigness: assignees.length),
            ),
        ],
      ),
    );
  }
}

class _OverflowAvatar extends StatelessWidget {
  const _OverflowAvatar({required this.totalAssigness});

  final int totalAssigness;

  @override
  Widget build(BuildContext context) {
    final overflow = totalAssigness - _kShownAvatarsNumbers;
    final overflowText = '+$overflow';
    final radius = kAppAvatarDefaultSize / 2;
    // Logic copied from [AppAvatar] widget
    final textFontSize = radius * 0.8;

    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.grey2,
      child: Text(
        overflowText,
        style: TextStyle(
          fontSize: textFontSize,
          color: AppColors.white1,
          fontWeight: FontWeight.w500,
          height: 1.0,
          textBaseline: TextBaseline.alphabetic,
        ),
        textHeightBehavior: const TextHeightBehavior(
          applyHeightToFirstAscent: false,
          applyHeightToLastDescent: false,
        ),
      ),
    );
  }
}
