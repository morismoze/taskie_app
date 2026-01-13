import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/colors.dart';
import '../../core/ui/app_icon.dart';
import '../view_models/locale_initializer_view_model.dart';

class LocaleInitializer extends StatefulWidget {
  const LocaleInitializer({
    super.key,
    required this.viewModel,
    required this.child,
  });

  final LocaleInitializerViewModel viewModel;
  final Widget child;

  @override
  State<LocaleInitializer> createState() => _LocaleInitializerState();
}

class _LocaleInitializerState extends State<LocaleInitializer> {
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
      listenable: widget.viewModel.initializeLocale,
      builder: (_, _) {
        if (!widget.viewModel.initializeLocale.running) {
          return widget.child;
        }

        return SizedBox.expand(
          child: Container(
            color: AppColors.white1,
            child: const Center(child: AppIcon()),
          ),
        );
      },
    );
  }
}
