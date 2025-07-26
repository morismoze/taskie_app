import 'package:flutter/material.dart';

import '../../../config/assets.dart';
import '../../core/theme/colors.dart';
import '../../core/ui/activity_indicator.dart';
import '../view_models/app_startup_view_model.dart';

class AppStartup extends StatelessWidget {
  const AppStartup({super.key, required this.viewModel, required this.child});

  final AppStartupViewModel viewModel;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel.bootstrap,
      builder: (_, _) {
        if (viewModel.bootstrap.running) {
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

        return child;
      },
    );
  }
}
