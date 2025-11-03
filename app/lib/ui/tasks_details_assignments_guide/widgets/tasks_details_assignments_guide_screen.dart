import 'package:flutter/material.dart';

import '../../core/l10n/l10n_extensions.dart';
import '../../core/theme/dimens.dart';
import '../../core/ui/blurred_circles_background.dart';
import '../../core/ui/guide_section.dart';
import '../../core/ui/header_bar/header_bar.dart';

class TasksDetailsAssignmentsGuideScreen extends StatelessWidget {
  const TasksDetailsAssignmentsGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlurredCirclesBackground(
        child: SafeArea(
          child: Column(
            children: [
              HeaderBar(
                title: context.localization.tasksAssignmentsGuideMainTitle,
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
                        GuideSection(
                          title: context
                              .localization
                              .tasksAssignmentsGuideAssignmentLimitTitle,
                          body: context
                              .localization
                              .tasksAssignmentsGuideAssignmentLimitBody,
                        ),
                        const SizedBox(height: 24),
                        GuideSection(
                          title: context
                              .localization
                              .tasksAssignmentsGuideAssignmentStatusesTitle,
                          body: context
                              .localization
                              .tasksAssignmentsGuideAssignmentStatusesBody,
                        ),
                        const SizedBox(height: 24),
                        GuideSection(
                          title: context
                              .localization
                              .tasksAssignmentsGuideMultipleAssigneesTitle,
                          body: context
                              .localization
                              .tasksAssignmentsGuideMultipleAssigneesBody,
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
