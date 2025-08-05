import 'package:flutter/material.dart';

import '../../core/l10n/l10n_extensions.dart';
import '../../core/theme/dimens.dart';
import '../../core/ui/activity_indicator.dart';
import '../../core/ui/blurred_circles_background.dart';
import '../../core/ui/header_bar/header_bar.dart';
import '../view_models/task_details_edit_form.dart';
import '../view_models/task_details_edit_screen_view_model.dart';

class TaskDetailsEditScreen extends StatefulWidget {
  const TaskDetailsEditScreen({super.key, required this.viewModel});

  final TaskDetailsEditScreenViewModel viewModel;

  @override
  State<TaskDetailsEditScreen> createState() => _TaskDetailsEditScreenState();
}

class _TaskDetailsEditScreenState extends State<TaskDetailsEditScreen> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.editTaskDetails.addListener(_onTaskDetailsEditResult);
  }

  @override
  void didUpdateWidget(covariant TaskDetailsEditScreen oldWidget) {
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
                        child: TaskDetailsEditForm(viewModel: widget.viewModel),
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

  void _onTaskDetailsEditResult() {}
}
