import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../config/assets.dart';
import '../../../routing/routes.dart';
import '../../core/l10n/l10n_extensions.dart';
import '../../core/theme/dimens.dart';
import '../../core/ui/activity_indicator.dart';
import '../../core/ui/app_snackbar.dart';
import '../../core/ui/blurred_circles_background.dart';
import '../../core/ui/empty_data_placeholder.dart';
import '../../core/ui/header_bar/app_header_action_button.dart';
import '../../core/ui/header_bar/header_bar.dart';
import '../view_models/create_goal_screen_viewmodel.dart';
import 'create_goal_form.dart';

class CreateGoalScreen extends StatefulWidget {
  const CreateGoalScreen({super.key, required this.viewModel});

  final CreateGoalScreenViewmodel viewModel;

  @override
  State<StatefulWidget> createState() => _WorkspaceSettingsScreenState();
}

class _WorkspaceSettingsScreenState extends State<CreateGoalScreen> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.createGoal.addListener(_onResult);
  }

  @override
  void didUpdateWidget(covariant CreateGoalScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.viewModel.createGoal.removeListener(_onResult);
    widget.viewModel.createGoal.addListener(_onResult);
  }

  @override
  void dispose() {
    widget.viewModel.createGoal.removeListener(_onResult);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlurredCirclesBackground(
        child: Column(
          children: [
            HeaderBar(
              title: context.localization.createNewGoalTitle,
              actions: [
                AppHeaderActionButton(
                  iconData: FontAwesomeIcons.house,
                  onTap: () {
                    context.go(
                      Routes.tasks(
                        workspaceId: widget.viewModel.activeWorkspaceId,
                      ),
                    );
                  },
                ),
                AppHeaderActionButton(
                  iconData: FontAwesomeIcons.question,
                  onTap: () => context.push(
                    Routes.goalsGuide(
                      workspaceId: widget.viewModel.activeWorkspaceId,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimens.of(context).paddingScreenHorizontal,
                ),
                child: ListenableBuilder(
                  listenable: widget.viewModel.loadWorkspaceMembers,
                  builder: (builderContext, child) {
                    if (widget.viewModel.loadWorkspaceMembers.running) {
                      return ActivityIndicator(
                        radius: 16,
                        color: Theme.of(builderContext).colorScheme.primary,
                      );
                    }

                    if (widget.viewModel.loadWorkspaceMembers.error) {
                      // TODO: Usage of a generic error prompt widget
                      return const SizedBox.shrink();
                    }

                    return child!;
                  },
                  child: ListenableBuilder(
                    listenable: widget.viewModel,
                    builder: (innerBuilderContext, _) {
                      if (widget.viewModel.workspaceMembers.isEmpty) {
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).padding.bottom * 2,
                          ),
                          child: Center(
                            child: EmptyDataPlaceholder(
                              assetImage: Assets.emptyMembersIllustration,
                              child: Text(
                                context.localization.createNewGoalNoMembers,
                                style: Theme.of(context).textTheme.bodyMedium,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        );
                      }

                      return SingleChildScrollView(
                        padding: EdgeInsets.symmetric(
                          vertical: Dimens.of(context).paddingScreenVertical,
                        ),
                        child: CreateGoalForm(viewModel: widget.viewModel),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onResult() {
    if (widget.viewModel.createGoal.completed) {
      widget.viewModel.createGoal.clearResult();
      AppSnackbar.showSuccess(
        context: context,
        message: context.localization.createNewGoalSuccess,
      );
      context.pop();
    }

    if (widget.viewModel.createGoal.error) {
      widget.viewModel.createGoal.clearResult();
      AppSnackbar.showError(
        context: context,
        message: context.localization.misc_somethingWentWrong,
      );
    }
  }
}
