import 'package:flutter/material.dart';

import '../../core/l10n/l10n_extensions.dart';
import '../../core/theme/dimens.dart';
import '../../core/ui/blurred_circles_background.dart';
import '../../core/ui/guide_section.dart';
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
                    padding: EdgeInsets.symmetric(
                      vertical: Dimens.of(context).paddingScreenVertical,
                      horizontal: Dimens.of(context).paddingScreenHorizontal,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GuideSection(
                          body: context
                              .localization
                              .workspaceUsersManagementUsersGuideIntroBody,
                        ),
                        const SizedBox(height: 24),
                        GuideSection(
                          title: context
                              .localization
                              .workspaceUsersManagementUsersGuideTeamMembersTitle,
                          body: context
                              .localization
                              .workspaceUsersManagementUsersGuideTeamMembersBody,
                        ),
                        const SizedBox(height: 24),
                        GuideSection(
                          title: context
                              .localization
                              .workspaceUsersManagementUsersGuideVirtualProfilesTitle,
                          body: context
                              .localization
                              .workspaceUsersManagementUsersGuideVirtualProfilesBody,
                        ),
                        const SizedBox(height: 24),
                        GuideSection(
                          title: context
                              .localization
                              .workspaceUsersManagementUsersGuideRolesTitle,
                          body: context
                              .localization
                              .workspaceUsersManagementUsersGuideRolesBody,
                        ),
                        const SizedBox(height: 24),
                        GuideSection(
                          title: context
                              .localization
                              .workspaceUsersManagementUsersGuideManagerRoleTitle,
                          body: context
                              .localization
                              .workspaceUsersManagementUsersGuideManagerRoleBody,
                        ),
                        const SizedBox(height: 24),
                        GuideSection(
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
