import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../data/services/api/exceptions/task_closed_exception.dart';
import '../../../routing/routes.dart';
import '../../../utils/command.dart';
import '../../core/l10n/l10n_extensions.dart';
import '../../core/theme/dimens.dart';
import '../../core/ui/activity_indicator.dart';
import '../../core/ui/app_dialog.dart';
import '../../core/ui/app_filled_button.dart';
import '../../core/ui/app_snackbar.dart';
import '../../core/ui/blurred_circles_background.dart';
import '../../core/ui/header_bar/header_bar.dart';
import '../../core/ui/separator.dart';
import '../view_models/task_details_edit_screen_view_model.dart';
import 'task_close_button.dart';
import 'task_details_edit_form.dart';
import 'task_details_meta.dart';

class TaskDetailsEditScreen extends StatefulWidget {
  const TaskDetailsEditScreen({super.key, required this.viewModel});

  final TaskDetailsEditScreenViewModel viewModel;

  @override
  State<TaskDetailsEditScreen> createState() => _TaskDetailsEditScreenState();
}

class _TaskDetailsEditScreenState extends State<TaskDetailsEditScreen> {
  @override
  void initState() {
    widget.viewModel.editTaskDetails.addListener(_onTaskDetailsEditResult);
    widget.viewModel.closeTask.addListener(_onTaskCloseResult);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant TaskDetailsEditScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.viewModel.editTaskDetails.removeListener(
      _onTaskDetailsEditResult,
    );
    oldWidget.viewModel.closeTask.removeListener(_onTaskCloseResult);
    widget.viewModel.editTaskDetails.addListener(_onTaskDetailsEditResult);
    widget.viewModel.closeTask.addListener(_onTaskCloseResult);
  }

  @override
  void dispose() {
    widget.viewModel.editTaskDetails.removeListener(_onTaskDetailsEditResult);
    widget.viewModel.closeTask.removeListener(_onTaskCloseResult);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlurredCirclesBackground(
        child: SafeArea(
          child: Column(
            children: [
              HeaderBar(title: context.localization.tasksDetailsEdit),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: Dimens.of(context).paddingScreenHorizontal,
                    right: Dimens.of(context).paddingScreenHorizontal,
                  ),
                  child: ListenableBuilder(
                    listenable: widget.viewModel,
                    builder: (builderContext, child) {
                      if (widget.viewModel.details == null) {
                        return ActivityIndicator(
                          radius: 16,
                          color: Theme.of(builderContext).colorScheme.primary,
                        );
                      }

                      return SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                          vertical: Dimens.paddingVertical,
                        ),
                        child: Column(
                          children: [
                            TaskDetailsMeta(viewModel: widget.viewModel),
                            const SizedBox(height: 20),
                            const Separator(),
                            const SizedBox(height: 40),
                            TaskDetailsEditForm(viewModel: widget.viewModel),
                            const SizedBox(height: 40),
                            const Separator(),
                            const SizedBox(height: 40),
                            TaskCloseButton(viewModel: widget.viewModel),
                          ],
                        ),
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

  void _onTaskDetailsEditResult() {
    if (widget.viewModel.editTaskDetails.completed) {
      widget.viewModel.editTaskDetails.clearResult();
      AppSnackbar.showSuccess(
        context: context,
        message: context.localization.tasksDetailsEditSuccess,
      );
    }

    if (widget.viewModel.editTaskDetails.error) {
      final errorResult = widget.viewModel.editTaskDetails.result as Error;
      widget.viewModel.editTaskDetails.clearResult();
      switch (errorResult.error) {
        case TaskClosedException():
          AppDialog.show(
            context: context,
            canPop: false,
            title: FaIcon(
              FontAwesomeIcons.circleInfo,
              color: Theme.of(context).colorScheme.primary,
              size: 30,
            ),
            content: Text(
              context.localization.tasksClosedTaskError,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            actions: [
              AppFilledButton(
                label: context.localization.misc_goToHomepage,
                onPress: () {
                  context.pop(); // Close dialog
                  context.go(
                    Routes.tasks(
                      workspaceId: widget.viewModel.activeWorkspaceId,
                    ),
                  );
                },
              ),
            ],
          );
          break;
        default:
          AppSnackbar.showError(
            context: context,
            message: context.localization.tasksDetailsEditError,
          );
      }
    }
  }

  void _onTaskCloseResult() {
    if (widget.viewModel.closeTask.completed) {
      widget.viewModel.closeTask.clearResult();
      AppSnackbar.showSuccess(
        context: context,
        message: context.localization.tasksDetailsCloseSuccess,
      );
      context.pop(); // Close dialog
      context.pop(); // Navigate back to tasks page
    }

    if (widget.viewModel.closeTask.error) {
      final errorResult = widget.viewModel.closeTask.result as Error;
      widget.viewModel.closeTask.clearResult();
      switch (errorResult.error) {
        case TaskClosedException():
          AppSnackbar.showError(
            context: context,
            message: context.localization.tasksClosedTaskError,
          );
          break;
        default:
          AppSnackbar.showError(
            context: context,
            message: context.localization.tasksDetailsEditError,
          );
      }
    }
  }
}
