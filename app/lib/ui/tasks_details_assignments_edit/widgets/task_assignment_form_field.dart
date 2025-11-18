import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../data/services/api/workspace/progress_status.dart';
import '../../core/l10n/l10n_extensions.dart';
import '../../core/theme/colors.dart';
import '../../core/ui/app_avatar.dart';
import '../../core/ui/app_select_field/app_select_field.dart';
import '../../core/ui/app_select_field/app_select_form_field.dart';
import '../../core/utils/extensions.dart';
import '../../core/utils/user.dart';

class TaskAssignmentFormField extends StatelessWidget {
  const TaskAssignmentFormField({
    super.key,
    required this.assigneeId,
    required this.firstName,
    required this.lastName,
    required this.status,
    required this.onStatusChanged,
    required this.removeAssignee,
    required this.profileImageUrl,
  });

  final String assigneeId;
  final String firstName;
  final String lastName;
  final ProgressStatus status;
  final void Function(String assigneeId, ProgressStatus status) onStatusChanged;
  final void Function(String assigneeId) removeAssignee;
  final String? profileImageUrl;

  @override
  Widget build(BuildContext context) {
    final options = [
      AppSelectFieldOption<ProgressStatus>(
        label: ProgressStatus.inProgress.l10n(context),
        value: ProgressStatus.inProgress,
      ),
      AppSelectFieldOption<ProgressStatus>(
        label: ProgressStatus.completed.l10n(context),
        value: ProgressStatus.completed,
      ),
      AppSelectFieldOption<ProgressStatus>(
        label: ProgressStatus.completedAsStale.l10n(context),
        value: ProgressStatus.completedAsStale,
      ),
      AppSelectFieldOption<ProgressStatus>(
        label: ProgressStatus.notCompleted.l10n(context),
        value: ProgressStatus.notCompleted,
      ),
    ];
    final activeStatus = AppSelectFieldOption<ProgressStatus>(
      label: status.l10n(context),
      value: status,
    );

    return Column(
      spacing: 16,
      children: [
        Row(
          spacing: 16,
          children: [
            AppAvatar(
              hashString: assigneeId,
              firstName: firstName,
              imageUrl: profileImageUrl,
            ),
            Expanded(
              child: Text(
                UserUtils.constructFullName(
                  firstName: firstName,
                  lastName: lastName,
                ),
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  height: 1,
                ),
              ),
            ),
            InkWell(
              onTap: () => removeAssignee(assigneeId),
              child: const FaIcon(
                FontAwesomeIcons.circleXmark,
                color: AppColors.black1,
                size: 22,
              ),
            ),
          ],
        ),
        AppSelectFormField.single(
          options: options,
          value: activeStatus,
          onChanged: (status) => onStatusChanged(assigneeId, status.value),
          label: context.localization.tasksAssignmentsEditStatusLabel,
        ),
      ],
    );
  }
}
