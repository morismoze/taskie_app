import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../config/assets.dart';
import '../../../routing/routes.dart';
import '../../core/l10n/l10n_extensions.dart';
import '../../core/theme/dimens.dart';
import '../../core/ui/activity_indicator.dart';
import '../../core/ui/app_toast.dart';
import '../../core/ui/blurred_circles_background.dart';
import '../../core/ui/empty_data_placeholder.dart';
import '../../core/ui/error_prompt.dart';
import '../../core/ui/header_bar/app_header_action_button.dart';
import '../../core/ui/header_bar/header_bar.dart';
import '../view_models/create_task_screen_view_model.dart';
import 'create_task_form.dart';

class CreateTaskScreen extends StatefulWidget {
  const CreateTaskScreen({super.key, required this.viewModel});

  final CreateTaskScreenViewmodel viewModel;

  @override
  State<StatefulWidget> createState() => _WorkspaceSettingsScreenState();
}

class _WorkspaceSettingsScreenState extends State<CreateTaskScreen> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.createTask.addListener(_onResult);
  }

  @override
  void didUpdateWidget(covariant CreateTaskScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.viewModel.createTask.removeListener(_onResult);
    widget.viewModel.createTask.addListener(_onResult);
  }

  @override
  void dispose() {
    widget.viewModel.createTask.removeListener(_onResult);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlurredCirclesBackground(
        child: Column(
          children: [
            HeaderBar(
              title: context.localization.createNewTaskTitle,
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
                    Routes.tasksGuide(
                      workspaceId: widget.viewModel.activeWorkspaceId,
                    ),
                  ),
                ),
              ],
            ),
            // Wrapped in Expanded because SingleChildScrollView is unbounded,
            // so Column doesn't know how share the space between HeaderBar and
            // SingleChildScrollView, so we need to explicitly tell Column that
            // SingleChildScrollView is the widget which should take the most entire
            // space left after HeaderBar is painted.
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimens.of(context).paddingScreenHorizontal,
                ),
                child: ListenableBuilder(
                  listenable: widget.viewModel.loadWorkspaceMembers,
                  builder: (builderContext, child) {
                    if (widget.viewModel.loadWorkspaceMembers.running) {
                      return const ActivityIndicator(radius: 16);
                    }

                    if (widget.viewModel.loadWorkspaceMembers.error) {
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).padding.bottom * 2,
                        ),
                        child: ErrorPrompt(
                          onRetry: () =>
                              widget.viewModel.loadWorkspaceMembers.execute(),
                          text: builderContext
                              .localization
                              .createNewGoalMembersLoadError,
                        ),
                      );
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
                                context.localization.createNewTaskNoMembers,
                                style: Theme.of(context).textTheme.bodyMedium,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        );
                      }

                      return SingleChildScrollView(
                        physics: const ClampingScrollPhysics(),
                        padding: EdgeInsets.symmetric(
                          vertical: Dimens.of(context).paddingScreenVertical,
                        ),
                        child: CreateTaskForm(viewModel: widget.viewModel),
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
    if (widget.viewModel.createTask.completed) {
      widget.viewModel.createTask.clearResult();
      AppToast.showSuccess(
        context: context,
        message: context.localization.createNewTaskSuccess,
      );
      context.pop(); // Go back to previous page
    }

    if (widget.viewModel.createTask.error) {
      widget.viewModel.createTask.clearResult();
      AppToast.showError(
        context: context,
        message: context.localization.createNewTaskError,
      );
    }
  }
}
