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
import '../../core/ui/app_toast.dart';
import '../../navigation/app_shell_scaffold.dart';
import '../view_models/auth_event_listener_view_model.dart';

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
  bool _handlingRemovalFromWorkspace = false;
  bool _handlingRoleChange = false;

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
            if (_handlingRoleChange) {
              return;
            }

            // Lock the event processing
            _handlingRoleChange = true;

            _dismissOverlays(); // Close overlays on the current page
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                _showRoleChangedDialog();
              }
            });
            return;
          case UserRemovedFromWorkspaceEvent():
            if (_handlingRemovalFromWorkspace) {
              return;
            }

            // Lock the event processing
            _handlingRemovalFromWorkspace = true;

            _dismissOverlays(); // Close overlays on the current page
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                _showRemovedFromWorkspaceDialog();
              }
            });
            return;
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
          submitButtonText: rootNavigatorContext.localization.misc_ok,
          submitButtonColor: Theme.of(rootNavigatorContext).colorScheme.error,
        ),
      ],
    );
  }

  void _showRemovedFromWorkspaceDialog() {
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
        rootNavigatorContext.localization.workspaceAccessRevocationMessage,
        style: Theme.of(rootNavigatorContext).textTheme.bodyMedium,
        textAlign: TextAlign.center,
      ),
      actions: [
        ActionButtonBar.withCommand(
          command: widget.viewModel.handleRemovalFromWorkspace,
          onSubmit: () => widget.viewModel.handleRemovalFromWorkspace.execute(),
          submitButtonText: rootNavigatorContext.localization.misc_ok,
          submitButtonColor: Theme.of(rootNavigatorContext).colorScheme.error,
        ),
      ],
    );
  }

  void _onWorkspaceRoleChangeResult() {
    if (widget.viewModel.handleWorkspaceRoleChange.completed ||
        widget.viewModel.handleWorkspaceRoleChange.error) {
      _handlingRoleChange = false;
    }

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

      _goSafe(Routes.tasks(workspaceId: activeWorkspaceId));
    }

    if (widget.viewModel.handleWorkspaceRoleChange.error) {
      widget.viewModel.handleWorkspaceRoleChange.clearResult();
      AppToast.showError(
        context: context,
        message: context.localization.misc_somethingWentWrong,
      );
      // Sign out if any error
      widget.viewModel.signOut.execute();
    }
  }

  void _onRemovalFromWorkspaceResult() {
    if (widget.viewModel.handleRemovalFromWorkspace.completed ||
        widget.viewModel.handleRemovalFromWorkspace.error) {
      _handlingRemovalFromWorkspace = false;
    }

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

      final target = workspaceId == null
          ? Routes.workspaceCreateInitial
          : Routes.tasks(workspaceId: workspaceId);

      _goSafe(target);
    }

    if (widget.viewModel.handleRemovalFromWorkspace.error) {
      widget.viewModel.handleRemovalFromWorkspace.clearResult();
      AppToast.showError(
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
      AppToast.showError(
        context: context,
        message: context.localization.misc_somethingWentWrong,
      );
      // As the last resort do the local sign out
      widget.viewModel.signOutLocally.execute();
    }
  }

  void _dismissOverlays() {
    // Close drawer if present
    appShellScaffoldKey.currentState?.closeDrawer();

    // Close dialogs + bottom sheets + snackbars (PopupRoutes) on the
    // *ROOT* navigator (root navigator meaning it closes every popup
    // even the ones which are not visually seen on the current screen
    // because the current screen is a e.g. a page over opened bottom
    // sheet). Important prerequisite for this is that all the popups
    // use useRootnavigator: true (which AppDialog and
    // AppModalBottomSheet are).
    final rootNav = rootNavigatorKey.currentState;
    rootNav?.popUntil((route) => route is! PopupRoute);
  }

  void _goSafe(String location) {
    final rootNavigatorState = rootNavigatorKey.currentState;

    if (rootNavigatorState == null) {
      return;
    }

    _dismissOverlays();

    final router = GoRouter.of(rootNavigatorState.context);
    router.go(location);

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _dismissOverlays(); // Close misc popus which maybe surfaced after navigation
    // });
  }
}
