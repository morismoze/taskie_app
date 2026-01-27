import 'package:flutter/material.dart';

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
    widget.viewModel.checkUser.addListener(_onUserCheckResult);
  }

  @override
  void didUpdateWidget(covariant AppLifecycleStateListener oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.viewModel.checkUser != oldWidget.viewModel.checkUser) {
      oldWidget.viewModel.checkUser.removeListener(_onUserCheckResult);
      widget.viewModel.checkUser.addListener(_onUserCheckResult);
    }
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

      if (result is Ok<CheckUserResult?>) {
        final value = result.value;

        if (value == null) {
          return;
        }

        switch (value) {
          case CheckUserResultChangedRole():
            widget.viewModel.emitChangedRoleEvent();
            break;
          case CheckUserResultRemovedFromWorkspace():
            widget.viewModel.emitRemovedfromWorkspaceEvent();
            break;
        }
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
