import 'package:flutter/material.dart';

import '../../../domain/constants/validation_rules.dart';
import '../../core/l10n/l10n_extensions.dart';
import '../../core/theme/dimens.dart';
import '../../core/ui/blurred_circles_background.dart';
import '../../core/ui/guide_section.dart';
import '../../core/ui/header_bar/header_bar.dart';

class TasksAssignmentsGuideScreen extends StatelessWidget {
  const TasksAssignmentsGuideScreen({super.key});

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
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: Dimens.of(context).paddingScreenVertical,
                      horizontal: Dimens.of(context).paddingScreenHorizontal,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: Dimens.paddingVertical,
                      children: [
                        GuideSection(
                          title: context
                              .localization
                              .tasksAssignmentsGuideAssignmentLimitTitle,
                          body: context.localization
                              .tasksAssignmentsGuideAssignmentLimitBody(
                                ValidationRules.taskMaxAssigneesCount,
                              ),
                        ),
                        GuideSection(
                          title: context
                              .localization
                              .tasksAssignmentsGuideAssignmentStatusesTitle,
                          body: context
                              .localization
                              .tasksAssignmentsGuideAssignmentStatusesBody,
                        ),
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
