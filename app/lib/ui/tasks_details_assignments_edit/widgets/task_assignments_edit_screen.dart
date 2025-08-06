import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/l10n_extensions.dart';
import '../../core/theme/dimens.dart';
import '../../core/ui/activity_indicator.dart';
import '../../core/ui/app_snackbar.dart';
import '../../core/ui/blurred_circles_background.dart';
import '../../core/ui/header_bar/header_bar.dart';
import '../view_models/task_assignments_edit_screen_view_model.dart';

class TaskAssignmentsEditScreen extends StatefulWidget {
  const TaskAssignmentsEditScreen({super.key, required this.viewModel});

  final TaskAssignmentsEditScreenViewModel viewModel;

  @override
  State<TaskAssignmentsEditScreen> createState() =>
      _TaskAssignmentsEditScreenState();
}

class _TaskAssignmentsEditScreenState extends State<TaskAssignmentsEditScreen> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.editTaskDetails.addListener(_onTaskDetailsEditResult);
  }

  @override
  void didUpdateWidget(covariant TaskAssignmentsEditScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.viewModel.editTaskDetails.removeListener(
      _onTaskDetailsEditResult,
    );
    widget.viewModel.editTaskDetails.addListener(_onTaskDetailsEditResult);
  }

  @override
  void dispose() {
    widget.viewModel.editTaskDetails.removeListener(_onTaskDetailsEditResult);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlurredCirclesBackground(
        child: SafeArea(
          child: Column(
            children: [
              HeaderBar(title: context.localization.tasksAssignmentsEdit),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: Dimens.of(context).paddingScreenHorizontal,
                    right: Dimens.of(context).paddingScreenHorizontal,
                  ),
                  child: ListenableBuilder(
                    listenable: widget.viewModel,
                    builder: (builderContext, child) {
                      if (widget.viewModel.assignees == null) {
                        return ActivityIndicator(
                          radius: 16,
                          color: Theme.of(builderContext).colorScheme.primary,
                        );
                      }

                      return const SingleChildScrollView(
                        padding: EdgeInsets.symmetric(
                          vertical: Dimens.paddingVertical,
                        ),
                        child: Text('data'),
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
        message: context.localization.taskDetailsEditSuccess,
      );
      context.pop(); // Navigate back to tasks page
    }

    if (widget.viewModel.editTaskDetails.error) {
      widget.viewModel.editTaskDetails.clearResult();
      AppSnackbar.showError(
        context: context,
        message: context.localization.taskDetailsEditError,
      );
    }
  }
}
