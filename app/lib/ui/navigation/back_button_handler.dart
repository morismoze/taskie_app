import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../core/l10n/l10n_extensions.dart';
import '../core/ui/app_snackbar.dart';
import 'app_bottom_navigation_bar/widgets/app_bottom_navigation_bar.dart';

class BackButtonHandler extends StatefulWidget {
  const BackButtonHandler({
    super.key,
    required this.child,
    required this.navigationShell,
  });

  final Widget child;
  final StatefulNavigationShell navigationShell;

  @override
  State<BackButtonHandler> createState() => _BackButtonHandlerState();
}

class _BackButtonHandlerState extends State<BackButtonHandler> {
  DateTime? _lastBackPress;
  static const exitAppPromptDuration = Duration(seconds: 2);

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) async {
        if (didPop) {
          return;
        }

        // 1. Check if we are on the Tasks tab
        final isTasksTab = widget.navigationShell.currentIndex == tasksTabIndex;

        if (!isTasksTab) {
          // If we are not on Tasks tab, then just navigate to Tasks tab
          widget.navigationShell.goBranch(0);
          return;
        }

        // 2. If we are on Tasks tab then implement exit app functionality
        final now = DateTime.now();

        if (_lastBackPress == null ||
            now.difference(_lastBackPress!) > exitAppPromptDuration) {
          _lastBackPress = now;

          if (mounted) {
            AppSnackbar.showInfo(
              context: context,
              message: context.localization.tasksPressAgainToExit,
              duration: exitAppPromptDuration,
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
