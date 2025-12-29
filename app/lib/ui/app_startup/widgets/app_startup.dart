import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/colors.dart';
import '../../core/ui/app_icon.dart';
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
        if (widget.viewModel.bootstrap.running) {
          return SizedBox.expand(
            child: Container(
              color: AppColors.white1,
              child: const Center(child: AppIcon()),
            ),
          );
        }

        return widget.child;
      },
    );
  }
}
