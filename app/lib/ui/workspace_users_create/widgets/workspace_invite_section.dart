import 'package:flutter/material.dart';

import '../../core/l10n/l10n_extensions.dart';
import '../../core/ui/activity_indicator.dart';
import '../../core/ui/app_text_field/app_text_field.dart';

class WorkspaceInviteSection extends StatelessWidget {
  const WorkspaceInviteSection({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 30,
      children: [
        Text(
          context
              .localization
              .workspaceUsersManagementCreateWorkspaceInviteDescription,
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
        ),
        ListenableBuilder(
          listenable: controller,
          builder: (context, child) {
            if (controller.text.isEmpty) {
              return const ActivityIndicator(radius: 11);
            } else {
              return AppTextField(
                controller: controller,
                readOnly: true,
                label: context
                    .localization
                    .workspaceUsersManagementCreateWorkspaceInviteLabel,
              );
            }
          },
        ),
      ],
    );
  }
}
