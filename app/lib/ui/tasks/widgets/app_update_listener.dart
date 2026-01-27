import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/l10n/l10n_extensions.dart';
import '../../core/ui/app_toast.dart';
import '../view_models/tasks_screen_view_model.dart';

class AppUpdateListener extends StatefulWidget {
  const AppUpdateListener({
    super.key,
    required this.viewModel,
    required this.child,
  });

  final TasksScreenViewModel viewModel;
  final Widget child;

  @override
  State<AppUpdateListener> createState() => _AppUpdateListenerState();
}

class _AppUpdateListenerState extends State<AppUpdateListener> {
  // Local guard, for possible rebuilds
  bool _isToastAlreadyShown = false;

  @override
  void initState() {
    super.initState();
    widget.viewModel.addListener(_checkUpdate);
  }

  @override
  void didUpdateWidget(covariant AppUpdateListener oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.viewModel != oldWidget.viewModel) {
      oldWidget.viewModel.removeListener(_checkUpdate);
      widget.viewModel.addListener(_checkUpdate);
      _checkUpdate();
    }
  }

  @override
  void dispose() {
    widget.viewModel.removeListener(_checkUpdate);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  void _checkUpdate() {
    if (widget.viewModel.shouldShowAppUpdate && !_isToastAlreadyShown) {
      _isToastAlreadyShown = true;
      // We use addPostFrameCallback to schedule the toast after the build phase.
      // This prevents the "build-during-build" error by ensuring the UI is fully
      // rendered before displaying an overlay side-effect.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showAppUpdateToast(context);
      });
    } else if (!widget.viewModel.shouldShowAppUpdate && _isToastAlreadyShown) {
      // Set to false only when the flag in the view model is set to false
      _isToastAlreadyShown = false;
    }
  }

  void _showAppUpdateToast(BuildContext context) {
    AppToast.showInfo(
      context: context,
      title: context.localization.appUpdateTitle,
      description: context.localization.appUpdateText(
        widget.viewModel.latestVersion,
      ),
      onTap: (item) {
        widget.viewModel.setAppUpdateVisibility(false);
        toastification.dismiss(item);
        launchUrl(
          Uri.parse(widget.viewModel.playStoreUrl),
          mode: LaunchMode.externalApplication,
        ).catchError((_) => false);
      },
      onDismissed: (_) => widget.viewModel.setAppUpdateVisibility(false),
      onCloseButtonTap: (item) {
        widget.viewModel.setAppUpdateVisibility(false);
        toastification.dismiss(item);
      },
      persistent: true,
    );
  }
}
