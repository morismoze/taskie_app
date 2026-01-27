import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../core/l10n/l10n_extensions.dart';
import '../core/ui/app_toast.dart';
import 'app_bottom_navigation_bar/widgets/app_bottom_navigation_bar.dart';
import 'app_shell_scaffold.dart';

class BackButtonHandler extends StatefulWidget {
  const BackButtonHandler({
    super.key,
    required this.child,
    this.navigationShell,
  });

  final Widget child;
  final StatefulNavigationShell? navigationShell;

  @override
  State<BackButtonHandler> createState() => _BackButtonHandlerState();
}

class _BackButtonHandlerState extends State<BackButtonHandler> {
  DateTime? _lastBackPress;
  static const _exitAppPromptDuration = Duration(seconds: 2);

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) async {
        if (didPop) {
          return;
        }

        if (widget.navigationShell != null) {
          // 1.a) Check if we are on the Tasks tab and drawer is opened
          if (appShellScaffoldKey.currentState != null &&
              appShellScaffoldKey.currentState!.isDrawerOpen) {
            context.pop();
            return;
          }

          // 1.b) Check if we are on the Tasks tab
          final isTasksTab =
              widget.navigationShell!.currentIndex == kTasksTabIndex;

          if (!isTasksTab) {
            // If we are not on Tasks tab, then just navigate to Tasks tab
            widget.navigationShell!.goBranch(0);
            return;
          }
        }

        // 2. If we are on Tasks tab (or JoinWorkspaceScreen) then implement exit app functionality
        final now = DateTime.now();

        if (_lastBackPress == null ||
            now.difference(_lastBackPress!) > _exitAppPromptDuration) {
          _lastBackPress = now;

          if (mounted) {
            AppToast.showInfo(
              context: context,
              title: context.localization.tasksPressAgainToExit,
              duration: _exitAppPromptDuration,
            );
          }
          return;
        }

        // Second press inside 2 seconds interval - exit the app
        await SystemNavigator.pop();
      },
      child: widget.child,
    );
  }
}
