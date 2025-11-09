import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../config/assets.dart';
import '../../../routing/routes.dart';
import '../../../utils/command.dart';
import '../../core/l10n/l10n_extensions.dart';
import '../../core/ui/activity_indicator.dart';
import '../../core/ui/app_snackbar.dart';
import '../../core/ui/blurred_circles_background.dart';
import '../../core/utils/constants.dart';
import '../view_models/entry_screen_viewmodel.dart';

class EntryScreen extends StatefulWidget {
  const EntryScreen({super.key, required this.viewModel});

  final EntryScreenViewModel viewModel;

  @override
  State<StatefulWidget> createState() => _EntryScreenState();
}

class _EntryScreenState extends State<EntryScreen> {
  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarContrastEnforced: false,
      ),
    );
    widget.viewModel.setupInitial.addListener(_onInitialLoad);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant EntryScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.viewModel.setupInitial.addListener(_onInitialLoad);
    oldWidget.viewModel.setupInitial.removeListener(_onInitialLoad);
  }

  @override
  void dispose() {
    widget.viewModel.setupInitial.removeListener(_onInitialLoad);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appIconSize = 90.0;
    final appIconBorderRadius =
        appIconSize * MiscConstants.appIconBorderRadiusSizePercentage;

    return Scaffold(
      body: SizedBox.expand(
        child: BlurredCirclesBackground(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.all(
                    Radius.circular(appIconBorderRadius),
                  ),
                  child: Image(
                    image: const AssetImage(Assets.appIcon),
                    height: appIconSize,
                    width: appIconSize,
                  ),
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
      ),
    );
  }

  void _onInitialLoad() {
    if (widget.viewModel.setupInitial.completed) {
      final activeWorkspaceId =
          (widget.viewModel.setupInitial.result as Ok<String?>).value;
      widget.viewModel.setupInitial.clearResult();
      if (activeWorkspaceId != null) {
        context.go(Routes.tasks(workspaceId: activeWorkspaceId));
      }
    }

    if (widget.viewModel.setupInitial.error) {
      widget.viewModel.setupInitial.clearResult();
      AppSnackbar.showError(
        context: context,
        message: context.localization.errorOnInitialLoad,
      );
      context.go(Routes.login);
    }
  }
}
