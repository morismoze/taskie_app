import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../../../domain/models/workspace_task.dart';
import '../../../core/theme/colors.dart';
import '../../../core/ui/app_avatar.dart';

/// Defines how many avatars will be shown before overflow avatar.
const kShownAvatarsNumbers = 3;

class TaskAssignees extends StatelessWidget {
  const TaskAssignees({super.key, required this.assignees});

  final List<WorkspaceTaskAssignee> assignees;

  @override
  Widget build(BuildContext context) {
    final shownAssignees = assignees.take(kShownAvatarsNumbers);
    // How much each avatar will overlap with each other
    const overlap = kAppAvatarSize / 2;
    // Total width
    final totalWidth =
        (assignees.length * (kAppAvatarSize - overlap)) + overlap;

    return SizedBox(
      width: totalWidth,
      height: kAppAvatarSize,
      child: Stack(
        children: [
          ...shownAssignees.mapIndexed((index, assignee) {
            final fullName = '${assignee.firstName} ${assignee.lastName}';
            return Positioned(
              left: (index * (40 - overlap)).toDouble(),
              child: AppAvatar(
                hashString: assignee.id,
                fullName: fullName,
                imageUrl: assignee.profileImageUrl,
              ),
            );
          }),
          if (assignees.length > 3)
            Positioned(
              left: (kShownAvatarsNumbers * (40 - overlap)).toDouble(),
              child: OverflowAvatar(totalAssigness: assignees.length),
            ),
        ],
      ),
    );
  }
}

class OverflowAvatar extends StatelessWidget {
  const OverflowAvatar({super.key, required this.totalAssigness});

  final int totalAssigness;

  @override
  Widget build(BuildContext context) {
    final overflow = totalAssigness - kShownAvatarsNumbers;
    final overflowText = '+$overflow';
    // Logic copied from [AppAvatar] widget
    final textFontSize = kAppAvatarRadius * 0.8;

    return CircleAvatar(
      radius: kAppAvatarRadius,
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
