import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../domain/models/interfaces/user_interface.dart';
import '../../core/l10n/l10n_extensions.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/dimens.dart';
import '../../core/ui/activity_indicator.dart';
import '../../core/ui/app_avatar.dart';
import '../../core/ui/blurred_circles_background.dart';
import '../../core/ui/header_bar/header_bar.dart';
import '../../core/ui/labeled_data/labeled_data.dart';
import '../../core/ui/labeled_data/labeled_data_text.dart';
import '../../core/ui/objective_status_chip.dart';
import '../../core/utils/extensions.dart';
import '../view_models/goal_details_screen_view_model.dart';

class GoalDetailsScreen extends StatelessWidget {
  const GoalDetailsScreen({super.key, required this.viewModel});

  final GoalDetailsScreenViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlurredCirclesBackground(
        child: SafeArea(
          child: Column(
            children: [
              HeaderBar(title: context.localization.goalsDetails),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    vertical: Dimens.of(context).paddingScreenVertical,
                    horizontal: Dimens.of(context).paddingScreenHorizontal,
                  ),
                  child: ListenableBuilder(
                    listenable: viewModel,
                    builder: (builderContext, child) {
                      final details = viewModel.details;

                      if (details == null) {
                        return const ActivityIndicator(radius: 16);
                      }

                      final createdByFullName = details.createdBy != null
                          ? details.createdBy!.fullName
                          : context
                                .localization
                                .workspaceSettingsOwnerDeletedAccount;
                      final statusColors = viewModel.details!.status.colors;

                      return Column(
                        children: [
                          // First section
                          FractionallySizedBox(
                            widthFactor: 0.8,
                            child: Text(
                              details.title,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                          ),
                          if (details.description != null) ...[
                            const SizedBox(
                              height: Dimens.paddingVertical / 2.25,
                            ),
                            FractionallySizedBox(
                              widthFactor: 0.9,
                              child: Text(
                                details.description!,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.titleMedium!
                                    .copyWith(color: AppColors.grey2),
                              ),
                            ),
                          ],

                          const SizedBox(height: Dimens.paddingVertical * 1.25),
                          // Second section
                          LabeledData(
                            label: context.localization.progressStatusLabel,
                            child: ObjectiveStatusChip(
                              status: details.status,
                              textColor: statusColors.textColor,
                              backgroundColor: statusColors.backgroundColor,
                            ),
                          ),
                          const SizedBox(height: Dimens.paddingVertical / 1.6),
                          LabeledData(
                            label: context.localization.goalRequiredPointsLabel,
                            child: LabeledDataText(
                              data: details.requiredPoints.toString(),
                            ),
                          ),
                          const SizedBox(height: Dimens.paddingVertical / 1.6),
                          LabeledData(
                            label: context.localization.goalsDetailsAssignedTo,
                            child: FractionallySizedBox(
                              widthFactor: 0.9,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                spacing: 8,
                                children: [
                                  AppAvatar(
                                    hashString: details.assignee.id,
                                    firstName: details.assignee.firstName,
                                    imageUrl: details.assignee.profileImageUrl,
                                  ),
                                  Flexible(
                                    child: Text(
                                      details.assignee.fullName,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(
                                            fontWeight: FontWeight.normal,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: Dimens.paddingVertical * 1.25),
                          LabeledData(
                            label:
                                context.localization.goalsDetailsEditCreatedAt,
                            child: LabeledDataText(
                              data: DateFormat.yMd(
                                Localizations.localeOf(context).toString(),
                              ).format(details.createdAt),
                            ),
                          ),
                          const SizedBox(height: Dimens.paddingVertical / 1.6),
                          LabeledData(
                            label:
                                context.localization.goalsDetailsEditCreatedBy,
                            child: FractionallySizedBox(
                              widthFactor: 0.9,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                spacing: 8,
                                children: [
                                  if (details.createdBy != null)
                                    AppAvatar(
                                      hashString: details.createdBy!.id,
                                      firstName: details.createdBy!.firstName,
                                      imageUrl:
                                          details.createdBy!.profileImageUrl,
                                    ),
                                  Flexible(
                                    child: Text(
                                      createdByFullName,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(
                                            fontWeight: FontWeight.normal,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
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
