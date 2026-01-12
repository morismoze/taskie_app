import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/l10n/l10n_extensions.dart';
import '../../core/ui/app_icon.dart';
import '../../core/ui/error_prompt.dart';
import '../view_models/app_startup_view_model.dart';

class AppStartup extends StatefulWidget {
  const AppStartup({super.key, required this.viewModel, required this.child});

  final AppStartupViewModel viewModel;
  final Widget child;

  @override
  State<AppStartup> createState() => _AppStartupState();
}

class _AppStartupState extends State<AppStartup> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarContrastEnforced: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.viewModel.bootstrap,
      builder: (_, _) {
        if (widget.viewModel.bootstrap.error) {
          return SizedBox.expand(
            child: Container(
              color: Theme.of(context).colorScheme.onPrimary,
              child: ErrorPrompt(
                text: context.localization.bootstrapError,
                onRetry: () => widget.viewModel.bootstrap.execute(),
              ),
            ),
          );
        }

        if (!widget.viewModel.bootstrap.running) {
          return widget.child;
        }

        return SizedBox.expand(
          child: Container(
            color: Theme.of(context).colorScheme.onPrimary,
            child: const Center(child: AppIcon()),
          ),
        );
      },
    );
  }
}
