import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/l10n_extensions.dart';
import '../../core/theme/dimens.dart';
import '../../core/ui/app_snackbar.dart';
import '../../core/ui/blurred_circles_background.dart';
import '../../core/ui/header_bar.dart';
import '../view_models/create_task_viewmodel.dart';
import 'create_task_form.dart';

class CreateTaskScreen extends StatefulWidget {
  const CreateTaskScreen({super.key, required this.viewModel});

  final CreateTaskViewmodel viewModel;

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
      body: SizedBox.expand(
        child: BlurredCirclesBackground(
          child: Column(
            children: [
              HeaderBar(
                title: context.localization.createNewTaskTitle,
                activeWorkspaceId: widget.viewModel.activeWorkspaceId,
              ),
              // Wrapped in Expanded because SingleChildScrollView is unbounded,
              // so Column doesn't know how share the space between HeaderBar and
              // SingleChildScrollView, so we need to explicitly tell Column that
              // SingleChildScrollView is the widget which should take the most entire
              // space left after HeaderBar is painted.
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: Dimens.paddingVertical,
                      left: Dimens.of(context).paddingScreenHorizontal,
                      right: Dimens.of(context).paddingScreenHorizontal,
                      bottom: Dimens.paddingVertical,
                    ),
                    child: CreateTaskForm(viewModel: widget.viewModel),
                  ),
                ),
              ),
            ],
          ),
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
      AppSnackbar.showError(
        context: context,
        message: context.localization.somethingWentWrong,
      );

      widget.viewModel.createTask.clearResult();
    }
  }
}
