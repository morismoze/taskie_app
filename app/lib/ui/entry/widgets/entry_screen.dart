import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../config/assets.dart';
import '../../../routing/routes.dart';
import '../../../utils/command.dart';
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
    widget.viewModel.loadWorkspaces.addListener(_onLoadWorkspacesResult);
  }

  @override
  void didUpdateWidget(covariant EntryScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.viewModel.loadWorkspaces.addListener(_onLoadWorkspacesResult);
    oldWidget.viewModel.loadWorkspaces.removeListener(_onLoadWorkspacesResult);
  }

  @override
  void dispose() {
    widget.viewModel.loadWorkspaces.removeListener(_onLoadWorkspacesResult);
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
                  child: Image(image: AssetImage(Assets.appIcon)),
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

  void _onLoadWorkspacesResult() {
    if (widget.viewModel.loadWorkspaces.completed) {
      final activeWorkspaceId =
          (widget.viewModel.loadWorkspaces.result as Ok<String?>).value;
      if (activeWorkspaceId == null) {
        context.go(Routes.login);
      } else {
        context.go(Routes.tasks(workspaceId: activeWorkspaceId));
      }
      widget.viewModel.loadWorkspaces.clearResult();
    }

    if (widget.viewModel.loadWorkspaces.error) {
      // If there was an error while loading up workspaces, we show a error
      // snackbar and redirect user to the login page
      widget.viewModel.loadWorkspaces.clearResult();
      AppSnackbar.showError(
        context: context,
        message: context.localization.errorWhileLoadingWorkspaces,
      );
      context.go(Routes.login);
    }
  }
}
