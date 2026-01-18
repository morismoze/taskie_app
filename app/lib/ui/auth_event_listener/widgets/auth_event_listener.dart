import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../data/services/local/auth_event_bus.dart';
import '../../../routing/router.dart';
import '../../../routing/routes.dart';
import '../../../utils/command.dart';
import '../../core/l10n/l10n_extensions.dart';
import '../../core/ui/action_button_bar.dart';
import '../../core/ui/app_dialog.dart';
import '../../core/ui/app_snackbar.dart';
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
    widget.viewModel.handleWorkspaceRoleChange.addListener(
      _onWorkspaceRoleChangeResult,
    );
    widget.viewModel.handleRemovalFromWorkspace.addListener(
      _onRemovalFromWorkspaceResult,
    );
    widget.viewModel.signOut.addListener(_onSignOutResult);

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
            _showRemovedFromWorkspaceDialog();
          case AccessTokenRefreshFailed():
            widget.viewModel.signOutLocally.execute();
        }
      });
    });
  }

  @override
  void didUpdateWidget(covariant AuthEventListener oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.viewModel.handleWorkspaceRoleChange.removeListener(
      _onWorkspaceRoleChangeResult,
    );
    oldWidget.viewModel.handleRemovalFromWorkspace.removeListener(
      _onRemovalFromWorkspaceResult,
    );
    oldWidget.viewModel.signOut.removeListener(_onSignOutResult);
    widget.viewModel.handleRemovalFromWorkspace.addListener(
      _onRemovalFromWorkspaceResult,
    );
    widget.viewModel.handleWorkspaceRoleChange.addListener(
      _onWorkspaceRoleChangeResult,
    );
    widget.viewModel.signOut.addListener(_onSignOutResult);
  }

  @override
  void dispose() {
    widget.viewModel.handleWorkspaceRoleChange.removeListener(
      _onWorkspaceRoleChangeResult,
    );
    widget.viewModel.handleRemovalFromWorkspace.removeListener(
      _onRemovalFromWorkspaceResult,
    );
    widget.viewModel.signOut.removeListener(_onSignOutResult);
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  void _showRoleChangedDialog() {
    final rootNavigatorContext = rootNavigatorKey.currentContext;
    if (rootNavigatorContext == null) {
      return;
    }

    AppDialog.showAlert(
      context: rootNavigatorContext,
      canPop: false,
      title: FaIcon(
        FontAwesomeIcons.circleExclamation,
        color: Theme.of(rootNavigatorContext).colorScheme.error,
        size: 30,
      ),
      content: Text(
        rootNavigatorContext.localization.workspaceRoleChangeMessage,
        style: Theme.of(rootNavigatorContext).textTheme.bodyMedium,
        textAlign: TextAlign.center,
      ),
      actions: [
        ActionButtonBar.withCommand(
          command: widget.viewModel.handleWorkspaceRoleChange,
          onSubmit: () => widget.viewModel.handleWorkspaceRoleChange.execute(),
          submitButtonText: context.localization.misc_ok,
          submitButtonColor: Theme.of(context).colorScheme.error,
        ),
      ],
    );
  }

  void _showRemovedFromWorkspaceDialog() {
    final dialogContext = rootNavigatorKey.currentContext;
    if (dialogContext == null) {
      return;
    }

    AppDialog.showAlert(
      context: dialogContext,
      canPop: false,
      title: FaIcon(
        FontAwesomeIcons.circleExclamation,
        color: Theme.of(dialogContext).colorScheme.error,
        size: 30,
      ),
      content: Text(
        dialogContext.localization.workspaceAccessRevocationMessage,
        style: Theme.of(dialogContext).textTheme.bodyMedium,
        textAlign: TextAlign.center,
      ),
      actions: [
        ActionButtonBar.withCommand(
          command: widget.viewModel.handleRemovalFromWorkspace,
          onSubmit: () => widget.viewModel.handleRemovalFromWorkspace.execute(),
          submitButtonText: context.localization.misc_ok,
          submitButtonColor: Theme.of(context).colorScheme.error,
        ),
      ],
    );
  }

  void _onWorkspaceRoleChangeResult() {
    final rootNavigatorContext = rootNavigatorKey.currentContext;

    if (widget.viewModel.handleWorkspaceRoleChange.completed) {
      widget.viewModel.handleWorkspaceRoleChange.clearResult();

      if (rootNavigatorContext == null) {
        // Sign out if any error
        widget.viewModel.signOut.execute();
        return;
      }

      // User could have been on a screen which is allowed only
      // to a higher role, so we navigate back to homepage
      final activeWorkspaceId = widget.viewModel.activeWorkspaceId;
      if (activeWorkspaceId == null) {
        // Sign out if any error
        widget.viewModel.signOut.execute();
        return;
      }
      // Close dialog
      rootNavigatorContext.pop();
      rootNavigatorContext.go(Routes.tasks(workspaceId: activeWorkspaceId));
    }

    if (widget.viewModel.handleWorkspaceRoleChange.error) {
      widget.viewModel.handleWorkspaceRoleChange.clearResult();
      AppSnackbar.showError(
        context: context,
        message: context.localization.misc_somethingWentWrong,
      );
      // Sign out if any error
      widget.viewModel.signOut.execute();
    }
  }

  void _onRemovalFromWorkspaceResult() {
    final rootNavigatorContext = rootNavigatorKey.currentContext;

    if (widget.viewModel.handleRemovalFromWorkspace.completed) {
      final workspaceId =
          (widget.viewModel.handleRemovalFromWorkspace.result as Ok<String?>)
              .value;
      widget.viewModel.handleRemovalFromWorkspace.clearResult();

      if (rootNavigatorContext == null) {
        // Sign out if any error
        widget.viewModel.signOut.execute();
        return;
      }

      if (workspaceId == null) {
        // User doesn't have any workspace left, so we navigate to initial workspace creation screen
        rootNavigatorContext.go(Routes.workspaceCreateInitial);
        return;
      }

      // Close dialog
      rootNavigatorContext.pop();
      // User could have been on a screen which is allowed only
      // to a higher role, so we navigate back to homepage
      rootNavigatorContext.go(Routes.tasks(workspaceId: workspaceId));
    }

    if (widget.viewModel.handleRemovalFromWorkspace.error) {
      widget.viewModel.handleRemovalFromWorkspace.clearResult();
      AppSnackbar.showError(
        context: context,
        message: context.localization.misc_somethingWentWrong,
      );
      // Sign out if any error
      widget.viewModel.signOut.execute();
    }
  }

  void _onSignOutResult() {
    if (widget.viewModel.signOut.completed) {
      widget.viewModel.signOut.clearResult();
    }

    if (widget.viewModel.signOut.error) {
      widget.viewModel.signOut.clearResult();
      AppSnackbar.showError(
        context: context,
        message: context.localization.misc_somethingWentWrong,
      );
    }
  }
}
