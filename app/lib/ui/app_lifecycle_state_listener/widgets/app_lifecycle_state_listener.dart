import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../utils/command.dart';
import '../view_models/app_lifecycle_state_listener_view_model.dart';

class AppLifecycleStateListener extends StatefulWidget {
  const AppLifecycleStateListener({
    super.key,
    required this.viewModel,
    required this.child,
  });

  final AppLifecycleStateListenerViewModel viewModel;
  final Widget child;

  @override
  State<AppLifecycleStateListener> createState() =>
      _AppLifecycleStateListenerState();
}

class _AppLifecycleStateListenerState extends State<AppLifecycleStateListener>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarContrastEnforced: false,
      ),
    );
    widget.viewModel.checkUser.addListener(_onUserCheckResult);
  }

  @override
  void didUpdateWidget(covariant AppLifecycleStateListener oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.viewModel.checkUser.addListener(_onUserCheckResult);
    oldWidget.viewModel.checkUser.removeListener(_onUserCheckResult);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      widget.viewModel.onAppResumed();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    widget.viewModel.checkUser.removeListener(_onUserCheckResult);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  void _onUserCheckResult() {
    if (widget.viewModel.checkUser.completed) {
      final result = widget.viewModel.checkUser.result;
      widget.viewModel.checkUser.clearResult();

      if (result is Ok<(bool, bool)?>) {
        final value = result.value;
        if (value == null) return;

        final (isMember, sameRole) = value;

        if (!isMember) {
          widget.viewModel.emitRemovedfromWorkspaceEvent();
        } else if (!sameRole)
          // ignore: curly_braces_in_flow_control_structures
          widget.viewModel.emitChangedRoleEvent();
      }
    }

    if (widget.viewModel.checkUser.error) {
      widget.viewModel.checkUser.clearResult();
      // No need to process this, because if this fails
      // any changes (removed from workspace, changed role)
      // will be detected on the next guarded requests.
    }
  }
}
