import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../routing/routes.dart';
import '../../core/l10n/l10n_extensions.dart';
import '../../core/theme/dimens.dart';
import '../../core/ui/activity_indicator.dart';
import '../../core/ui/app_outlined_button.dart';
import '../../core/ui/app_snackbar.dart';
import '../../core/ui/blurred_circles_background.dart';
import '../../core/ui/header_bar/app_header_action_button.dart';
import '../../core/ui/header_bar/header_bar.dart';
import '../view_models/create_task_screen_viewmodel.dart';
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
              ],
            ),
            // Wrapped in Expanded because SingleChildScrollView is unbounded,
            // so Column doesn't know how share the space between HeaderBar and
            // SingleChildScrollView, so we need to explicitly tell Column that
            // SingleChildScrollView is the widget which should take the most entire
            // space left after HeaderBar is painted.
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  left: Dimens.of(context).paddingScreenHorizontal,
                  right: Dimens.of(context).paddingScreenHorizontal,
                  bottom: Dimens.paddingVertical,
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
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            FractionallySizedBox(
                              widthFactor: 0.9,
                              child: Text(
                                innerBuilderContext
                                    .localization
                                    .createNewTaskNoMembers,
                                textAlign: TextAlign.center,
                                style: Theme.of(
                                  innerBuilderContext,
                                ).textTheme.bodyMedium,
                              ),
                            ),
                            const SizedBox(height: 20),
                            AppOutlinedButton(
                              label: innerBuilderContext
                                  .localization
                                  .objectiveNoMembersCta,
                              onPress: () => innerBuilderContext.push(
                                Routes.workspaceUsers(
                                  workspaceId:
                                      widget.viewModel.activeWorkspaceId,
                                ),
                              ),
                            ),
                          ],
                        );
                      }

                      return SingleChildScrollView(
                        padding: EdgeInsets.only(
                          top: Dimens.paddingVertical,
                          bottom: MediaQuery.of(context).padding.bottom,
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
      context.pop();
    }

    if (widget.viewModel.createTask.error) {
      widget.viewModel.createTask.clearResult();
      AppSnackbar.showError(
        context: context,
        message: context.localization.misc_somethingWentWrong,
      );
    }
  }
}
