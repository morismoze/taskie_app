import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../data/services/local/auth_event_bus.dart';
import '../../core/l10n/l10n_extensions.dart';
import '../../core/ui/action_button_bar.dart';
import '../../core/ui/app_dialog.dart';
import '../view_models/auth_event_listener_viewmodel.dart';

class AuthEventListener extends StatefulWidget {
  const AuthEventListener({
    super.key,
    required this.viewModel,
    required this.child,
  });

  final AuthEventListenerViewmodel viewModel;
  final Widget child;

  @override
  State<AuthEventListener> createState() => _AuthEventListenerState();
}

class _AuthEventListenerState extends State<AuthEventListener> {
  StreamSubscription<AuthEvent>? _subscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final eventBus = context.read<AuthEventBus>();

      _subscription = eventBus.events.listen((event) {
        if (!mounted) {
          return;
        }

        switch (event) {
          case UserRoleChangedEvent():
            _showRoleChangedDialog();
          case UserRemovedFromWorkspaceEvent():
            _showKickedDialog();
        }
      });
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  void _showRoleChangedDialog() {
    AppDialog.showAlert(
      context: context,
      canPop: false,
      title: FaIcon(
        FontAwesomeIcons.circleExclamation,
        color: Theme.of(context).colorScheme.error,
        size: 30,
      ),
      // TODO: change the text
      content: Text(
        context.localization.goalsClosedGoalError,
        style: Theme.of(context).textTheme.bodyMedium,
        textAlign: TextAlign.center,
      ),
      actions: [
        ActionButtonBar.withCommand(
          command: widget.viewModel.handleWorkspaceRoleChange,
          onSubmit: (BuildContext builderContext) =>
              widget.viewModel.handleRemovalFromWorkspace.execute(),
          submitButtonText: (BuildContext builderContext) =>
              builderContext.localization.misc_ok,
          submitButtonColor: (BuildContext builderContext) =>
              Theme.of(builderContext).colorScheme.error,
        ),
      ],
    );
  }

  void _showKickedDialog() {
    AppDialog.showAlert(
      context: context,
      canPop: false,
      title: FaIcon(
        FontAwesomeIcons.circleExclamation,
        color: Theme.of(context).colorScheme.error,
        size: 30,
      ),
      // TODO: change the text
      content: Text(
        context.localization.goalsClosedGoalError,
        style: Theme.of(context).textTheme.bodyMedium,
        textAlign: TextAlign.center,
      ),
      actions: [
        ActionButtonBar.withCommand(
          command: widget.viewModel.handleRemovalFromWorkspace,
          onSubmit: (BuildContext builderContext) =>
              widget.viewModel.handleRemovalFromWorkspace.execute(),
          submitButtonText: (BuildContext builderContext) =>
              builderContext.localization.misc_ok,
          submitButtonColor: (BuildContext builderContext) =>
              Theme.of(builderContext).colorScheme.error,
        ),
      ],
    );
  }
}
