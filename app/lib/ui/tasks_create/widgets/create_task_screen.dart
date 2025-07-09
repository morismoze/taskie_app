import 'package:flutter/material.dart';

import '../../core/l10n/l10n_extensions.dart';
import '../../core/theme/dimens.dart';
import '../../core/ui/blurred_circles_background.dart';
import '../../core/ui/header_bar.dart';
import '../view_models/create_task_viewmodel.dart';
import 'form.dart';

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
  }

  @override
  void didUpdateWidget(covariant CreateTaskScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: BlurredCirclesBackground(
          child: SafeArea(
            child: Column(
              children: [
                HeaderBar(title: context.localization.createNewTaskTitle),
                Padding(
                  padding: EdgeInsets.only(
                    top: Dimens.paddingVertical,
                    left: Dimens.of(context).paddingScreenHorizontal,
                    right: Dimens.of(context).paddingScreenHorizontal,
                    bottom: Dimens.paddingVertical,
                  ),
                  child: CreateForm(viewModel: widget.viewModel),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
