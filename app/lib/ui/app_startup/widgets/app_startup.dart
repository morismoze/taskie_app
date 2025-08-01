import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../config/assets.dart';
import '../../core/theme/colors.dart';
import '../../core/ui/activity_indicator.dart';
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
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      child: Image(image: AssetImage(Assets.appIcon)),
                    ),
                    const SizedBox(height: 18),
                    ActivityIndicator(
                      radius: 16,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return widget.child;
      },
    );
  }
}
