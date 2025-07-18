import 'package:flutter/material.dart';

import '../../core/l10n/l10n_extensions.dart';
import '../../core/theme/dimens.dart';
import '../../core/ui/blurred_circles_background.dart';
import '../../core/ui/header_bar/header_bar.dart';

class WorkspaceUsersManagementGuideScreen extends StatelessWidget {
  const WorkspaceUsersManagementGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlurredCirclesBackground(
        child: SafeArea(
          child: Column(
            children: [
              HeaderBar(
                title: context
                    .localization
                    .workspaceUsersManagementUsersGuideMainTitle,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: Dimens.paddingVertical,
                      left: Dimens.of(context).paddingScreenHorizontal,
                      right: Dimens.of(context).paddingScreenHorizontal,
                      bottom: Dimens.paddingVertical,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context
                              .localization
                              .workspaceUsersManagementUsersGuideIntroBody,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 24),
                        _Section(
                          title: context
                              .localization
                              .workspaceUsersManagementUsersGuideTeamMembersTitle,
                          body: context
                              .localization
                              .workspaceUsersManagementUsersGuideTeamMembersBody,
                        ),
                        const SizedBox(height: 24),
                        _Section(
                          title: context
                              .localization
                              .workspaceUsersManagementUsersGuideVirtualProfilesTitle,
                          body: context
                              .localization
                              .workspaceUsersManagementUsersGuideVirtualProfilesBody,
                        ),
                        const SizedBox(height: 24),
                        _Section(
                          title: context
                              .localization
                              .workspaceUsersManagementUsersGuideRolesTitle,
                          body: context
                              .localization
                              .workspaceUsersManagementUsersGuideRolesBody,
                        ),
                        const SizedBox(height: 24),
                        _Section(
                          title: context
                              .localization
                              .workspaceUsersManagementUsersGuideManagerRoleTitle,
                          body: context
                              .localization
                              .workspaceUsersManagementUsersGuideManagerRoleBody,
                        ),
                        const SizedBox(height: 24),
                        _Section(
                          title: context
                              .localization
                              .workspaceUsersManagementUsersGuideMemberRoleTitle,
                          body: context
                              .localization
                              .workspaceUsersManagementUsersGuideMemberRoleBody,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(body, style: Theme.of(context).textTheme.bodyLarge),
      ],
    );
  }
}
