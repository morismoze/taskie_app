import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../routing/routes.dart';
import '../../../utils/command.dart';
import '../../core/l10n/l10n_extensions.dart';
import '../../core/theme/dimens.dart';
import '../../core/ui/activity_indicator.dart';
import '../../core/ui/app_filled_button.dart';
import '../../core/ui/app_icon.dart';
import '../../core/ui/blurred_circles_background.dart';
import '../view_models/entry_screen_viewmodel.dart';

/// This is business logic init
class EntryScreen extends StatefulWidget {
  const EntryScreen({super.key, required this.viewModel});

  final EntryScreenViewModel viewModel;

  @override
  State<StatefulWidget> createState() => _EntryScreenState();
}

class _EntryScreenState extends State<EntryScreen> {
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
    widget.viewModel.setupInitial.addListener(_onInitialLoad);
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
    return Scaffold(
      body: SizedBox.expand(
        child: BlurredCirclesBackground(
          child: Stack(
            children: [
              const Center(child: AppIcon()),
              Align(
                alignment: Alignment.bottomCenter,
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimens.of(context).paddingScreenHorizontal,
                      vertical: Dimens.paddingVertical * 2,
                    ),
                    child: ListenableBuilder(
                      listenable: widget.viewModel.setupInitial,
                      builder: (builderContext, _) {
                        if (widget.viewModel.setupInitial.error) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            spacing: Dimens.paddingVertical,
                            children: [
                              FractionallySizedBox(
                                widthFactor: 0.9,
                                child: Text(
                                  builderContext
                                      .localization
                                      .errorOnInitialLoad,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(
                                    builderContext,
                                  ).textTheme.bodyMedium,
                                ),
                              ),
                              AppFilledButton(
                                onPress: () =>
                                    widget.viewModel.setupInitial.execute(),
                                label: builderContext.localization.misc_retry,
                              ),
                            ],
                          );
                        }

                        return const ActivityIndicator(radius: 16);
                      },
                    ),
                  ),
                ),
              ),
            ],
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

      // Check if 'from' query param is not empty and valid
      // and if it is navigate to that route
      final nextRoute = GoRouterState.of(context).uri.queryParameters['next'];

      if (nextRoute != null) {
        final decodedRoute = Uri.decodeComponent(nextRoute);

        // Check if user has access to this route, specifically
        // to the workspaceId from that route, if it exists as
        // path param

        final regExp = RegExp('/${Routes.workspacesRelative}/([^/]+)');
        final match = regExp.firstMatch(decodedRoute);
        final decodedWorkspaceIdPathParam = match?.group(1);
        // If there is no workspaceId path param then just let the user on that route
        if (decodedWorkspaceIdPathParam == null) {
          context.go(decodedRoute);
          return;
        }

        if (widget.viewModel.checkRouteWorkspaceId(
          decodedWorkspaceIdPathParam,
        )) {
          context.go(decodedRoute);
        } else {
          if (activeWorkspaceId != null) {
            context.go(Routes.tasks(workspaceId: activeWorkspaceId));
          } else {
            // activeWorkspaceId is null only if user's workspaces list is empty
            // and in that case hasNoWorkspaces WorkspaceRepository flag will
            // kick in GoRouter's redirect function
          }
        }
      } else {
        if (activeWorkspaceId != null) {
          context.go(Routes.tasks(workspaceId: activeWorkspaceId));
        } else {
          // activeWorkspaceId is null only if user's workspaces list is empty
          // and in that case hasNoWorkspaces WorkspaceRepository flag will
          // kick in GoRouter's redirect function
        }
      }
    }
  }
}
