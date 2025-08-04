import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../domain/constants/rbac.dart';
import '../../../routing/routes.dart';
import '../../core/l10n/l10n_extensions.dart';
import '../../core/theme/dimens.dart';
import '../../core/ui/activity_indicator.dart';
import '../../core/ui/blurred_circles_background.dart';
import '../../core/ui/header_bar/app_header_action_button.dart';
import '../../core/ui/header_bar/header_bar.dart';
import '../../core/ui/labeled_data/labeled_data.dart';
import '../../core/ui/labeled_data/labeled_data_text.dart';
import '../../core/ui/rbac.dart';
import '../view_models/task_details_screen_view_model.dart';

class TaskDetailsScreen extends StatelessWidget {
  const TaskDetailsScreen({super.key, required this.viewModel});

  final TaskDetailsScreenViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlurredCirclesBackground(
        child: SafeArea(
          child: Column(
            children: [
              HeaderBar(
                title: context.localization.tasksDetails,
                actions: [
                  ListenableBuilder(
                    listenable: viewModel,
                    builder: (builderContext, _) {
                      return Rbac(
                        permission: RbacPermission.objectiveEdit,
                        child: AppHeaderActionButton(
                          iconData: FontAwesomeIcons.pencil,
                          onTap: () {
                            final taskId = viewModel.details?.id;

                            if (taskId != null) {
                              context.push(
                                Routes.taskEditDetails(
                                  workspaceId: viewModel.activeWorkspaceId,
                                  taskId: taskId,
                                ),
                              );
                            }
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
              SingleChildScrollView(
                padding: EdgeInsets.only(
                  top: Dimens.paddingVertical,
                  left: Dimens.of(context).paddingScreenHorizontal,
                  right: Dimens.of(context).paddingScreenHorizontal,
                  bottom: Dimens.paddingVertical,
                ),
                child: ListenableBuilder(
                  listenable: viewModel,
                  builder: (builderContext, _) {
                    final details = viewModel.details;

                    if (details == null) {
                      return ActivityIndicator(
                        radius: 11,
                        color: Theme.of(builderContext).colorScheme.primary,
                      );
                    }

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
                          const SizedBox(height: 15),
                          LabeledData(
                            label: context.localization.taskDescriptionLabel,
                            child: LabeledDataText(data: details.description!),
                          ),
                        ],
                        const SizedBox(height: 15),
                        LabeledData(
                          label: context.localization.taskRewardPointsLabel,
                          child: LabeledDataText(
                            data: details.rewardPoints.toString(),
                          ),
                        ),
                        const SizedBox(height: 30),
                        // Second section
                        // assignees ....
                        // Third section
                        // test
                        LabeledData(
                          label: context.localization.tasksDetailsCreatedAt,
                          child: LabeledDataText(
                            data: DateFormat.yMd(
                              Localizations.localeOf(context).toString(),
                            ).format(details.createdAt),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
