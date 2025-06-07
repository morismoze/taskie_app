import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../routing/routes.dart';
import '../../core/l10n/l10n_extensions.dart';
import '../../core/ui/activity_indicator.dart';
import '../../core/ui/app_snackbar.dart';
import '../../core/ui/blurred_circles_background.dart';
import '../view_models/entry_viewmodel.dart';

class EntryScreen extends StatefulWidget {
  const EntryScreen({super.key, required this.viewModel});

  final EntryViewModel viewModel;

  @override
  State<StatefulWidget> createState() => _EntryScreenState();
}

class _EntryScreenState extends State<EntryScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarColor: Colors.transparent,
      ),
    );
    widget.viewModel.loadWorkspaces.addListener(_onResult);
  }

  @override
  void didUpdateWidget(covariant EntryScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.viewModel.loadWorkspaces.removeListener(_onResult);
    widget.viewModel.loadWorkspaces.addListener(_onResult);
  }

  @override
  void dispose() {
    widget.viewModel.loadWorkspaces.removeListener(_onResult);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: BlurredCirclesBackground(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  child: Image(image: AssetImage('assets/images/app_icon.png')),
                ),
                const SizedBox(height: 18),
                ActivityIndicator(
                  radius: 16,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onResult() {
    if (widget.viewModel.loadWorkspaces.completed) {
      widget.viewModel.loadWorkspaces.clearResult();
      if (widget.viewModel.workspaces.isEmpty) {
        return context.go(Routes.createWorkspace);
      }
      return context.go(Routes.tasks);
    }

    if (widget.viewModel.loadWorkspaces.error) {
      widget.viewModel.loadWorkspaces.clearResult();
      AppSnackbar.of(context).showError(
        message: context.localization.errorWhileLoadingWorkspaces,
        actionData: AppSnackBarActionData(
          label: context.localization.tryAgain,
          onPressed: widget.viewModel.loadWorkspaces.execute,
        ),
      );
    }
  }
}
