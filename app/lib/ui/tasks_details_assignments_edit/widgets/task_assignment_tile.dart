import 'package:flutter/material.dart';

import '../../../data/services/api/workspace/progress_status.dart';
import '../../../domain/models/workspace_task.dart';
import '../../core/l10n/l10n_extensions.dart';
import '../../core/ui/app_avatar.dart';
import '../../core/ui/app_select_field/app_select_field.dart';
import '../../core/utils/extensions.dart';
import '../../core/utils/user.dart';

class TaskAssignmentTile extends StatefulWidget {
  const TaskAssignmentTile({super.key, required this.assignee});

  final WorkspaceTaskAssignee assignee;

  @override
  State<TaskAssignmentTile> createState() => _TaskAssignmentTileState();
}

class _TaskAssignmentTileState extends State<TaskAssignmentTile> {
  late AppSelectFieldOption _activeStatus;

  @override
  void initState() {
    super.initState();
    setState(() {
      _activeStatus = AppSelectFieldOption(
        label: widget.assignee.status.l10n(context),
        value: widget.assignee.status,
      );
    });
  }

  void _onStatusChange(List<AppSelectFieldOption> selectedOptions) {
    // invoke view model command
  }

  @override
  Widget build(BuildContext context) {
    final options = [
      AppSelectFieldOption(
        label: ProgressStatus.inProgress.l10n(context),
        value: ProgressStatus.inProgress,
      ),
      AppSelectFieldOption(
        label: ProgressStatus.completed.l10n(context),
        value: ProgressStatus.completed,
      ),
      AppSelectFieldOption(
        label: ProgressStatus.completedAsStale.l10n(context),
        value: ProgressStatus.completedAsStale,
      ),
      AppSelectFieldOption(
        label: ProgressStatus.notCompleted.l10n(context),
        value: ProgressStatus.notCompleted,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        spacing: 16,
        children: [
          Row(
            spacing: 16,
            children: [
              AppAvatar(
                hashString: widget.assignee.id,
                firstName: widget.assignee.firstName,
                imageUrl: widget.assignee.profileImageUrl,
              ),
              Text(
                UserUtils.constructFullName(
                  firstName: widget.assignee.firstName,
                  lastName: widget.assignee.lastName,
                ),
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  height: 1,
                ),
              ),
            ],
          ),
          AppSelectField(
            options: options,
            value: [_activeStatus],
            onChanged: _onStatusChange,
            onCleared: () {},
            label: context.localization.tasksAssignmentsEditStatusLabel,
          ),
        ],
      ),
    );
  }
}
