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
import '../view_models/entry_screen_view_model.dart';

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

    if (widget.viewModel.setupInitial != oldWidget.viewModel.setupInitial) {
      oldWidget.viewModel.setupInitial.removeListener(_onInitialLoad);
      widget.viewModel.setupInitial.addListener(_onInitialLoad);
    }
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

  void _onInitialLoad() async {
    if (widget.viewModel.setupInitial.completed) {
      final activeWorkspaceId =
          (widget.viewModel.setupInitial.result as Ok<String?>).value;
      widget.viewModel.setupInitial.clearResult();

      final qp = GoRouterState.of(context).uri.queryParameters;
      final nextRoute = qp['next'];
      final fromUid = qp['from_uid'];
      final currentUserId = widget.viewModel.user?.id;

      // We only honor the `next` route if it belongs to the same user session.
      //
      // When the app redirects to login, we store both:
      // - `from`/`next`: the route the user attempted to access
      // - `from_uid`: the userId of the currently logged-in user at that moment
      //
      // This prevents leaking a "return-to" route across different accounts.
      // Example: if the refresh token expires (or the user logs out) and the user then logs
      // in as a different account, we must NOT navigate the new user to a route that
      // was captured for the previous user. Therefore, `next` is considered valid
      // only when `from_uid` matches the currently authenticated userId.
      final canUseNext =
          nextRoute != null &&
          nextRoute.isNotEmpty &&
          fromUid != null &&
          fromUid.isNotEmpty &&
          currentUserId != null &&
          currentUserId.isNotEmpty &&
          fromUid == currentUserId;

      if (canUseNext) {
        // Check if user has access to this route, specifically
        // to the workspaceId from that route, if it exists as
        // path param

        // Detect UUIDv4 workspaceId
        final regExp = RegExp(
          '^/${Routes.workspacesRelative}/'
          r'([0-9a-fA-F]{8}-[0-9a-fA-F]{4}-4[0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12})(?=/|$)',
        );
        final match = regExp.firstMatch(nextRoute);
        final decodedPathParamWorkspaceId = match?.group(1);
        // If there is no workspaceId path param then just let the user on that route
        if (decodedPathParamWorkspaceId == null) {
          context.go(nextRoute);
          return;
        }

        if (widget.viewModel.checkRouteWorkspaceId(
          decodedPathParamWorkspaceId,
        )) {
          await widget.viewModel.setActiveWorkspaceId(
            decodedPathParamWorkspaceId,
          );
          if (!mounted) {
            return;
          }
          context.go(nextRoute);
          return;
        }
      }

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
