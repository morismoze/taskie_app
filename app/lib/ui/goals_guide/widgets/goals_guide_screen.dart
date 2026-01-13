import 'package:flutter/material.dart';

import '../../core/l10n/l10n_extensions.dart';
import '../../core/theme/dimens.dart';
import '../../core/ui/blurred_circles_background.dart';
import '../../core/ui/guide_section.dart';
import '../../core/ui/header_bar/header_bar.dart';

class GoalsGuideScreen extends StatelessWidget {
  const GoalsGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlurredCirclesBackground(
        child: SafeArea(
          child: Column(
            children: [
              HeaderBar(title: context.localization.goalsGuideMainTitle),
              Expanded(
                child: SingleChildScrollView(
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
                          body: context.localization.goalsGuideBaseInfoBody,
                        ),
                        GuideSection(
                          title: context
                              .localization
                              .goalsGuideAssignmentLimitTitle,
                          body: context
                              .localization
                              .goalsGuideAssignmentLimitBody,
                        ),
                        GuideSection(
                          title: context.localization.goalsGuideStatusesTitle,
                          body: context.localization.goalsGuideStatusesBody,
                        ),
                        GuideSection(
                          title: context
                              .localization
                              .goalsGuideRequiredPointsTitle,
                          body:
                              context.localization.goalsGuideRequiredPointsBody,
                        ),
                        GuideSection(
                          title: context.localization.goalsGuideNoteTitle,
                          body: context.localization.goalsGuideNoteBody,
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
