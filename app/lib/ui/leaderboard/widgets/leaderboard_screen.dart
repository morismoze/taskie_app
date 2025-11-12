import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../config/assets.dart';
import '../../core/l10n/l10n_extensions.dart';
import '../../core/theme/dimens.dart';
import '../../core/ui/activity_indicator.dart';
import '../../core/ui/app_snackbar.dart';
import '../../core/ui/blurred_circles_background.dart';
import '../../core/ui/empty_data_placeholder.dart';
import '../view_models/leaderboard_screen_view_model.dart';
import 'leaderboard_header_content.dart';
import 'leaderboard_list.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key, required this.viewModel});

  final LeaderboardScreenViewModel viewModel;

  @override
  State<StatefulWidget> createState() => _WorkspaceUsersManagementScreenState();
}

class _WorkspaceUsersManagementScreenState extends State<LeaderboardScreen> {
  @override
  void initState() {
    widget.viewModel.loadLeaderboard.addListener(_onLeaderboardLoadResult);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant LeaderboardScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.viewModel.loadLeaderboard.removeListener(
      _onLeaderboardLoadResult,
    );
    widget.viewModel.loadLeaderboard.addListener(_onLeaderboardLoadResult);
  }

  @override
  void dispose() {
    widget.viewModel.loadLeaderboard.removeListener(_onLeaderboardLoadResult);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final headerHeight = MediaQuery.of(context).size.height * 0.15;
    final refreshIndicatorEdgeOffset =
        headerHeight + MediaQuery.of(context).viewPadding.top;

    return Scaffold(
      body: BlurredCirclesBackground(
        child: ListenableBuilder(
          listenable: widget.viewModel,
          builder: (builderContext, child) {
            // We don't have the standard 'First ListenableBuilder listening to a command
            // and its child is the second ListenableBuilder listening to viewModel' because
            // we want to show [ActivityIndicator] only on the initial load. All other loads
            // after that will happen when user pulls-to-refresh (and if the app process was not
            // killed by the underlying OS). And in that case we want to show the existing
            // list and only the refresh indicator loader - not [ActivityIndicator] everytime.
            return RefreshIndicator(
              displacement: 30,
              edgeOffset: refreshIndicatorEdgeOffset,
              onRefresh: () async {
                widget.viewModel.loadLeaderboard.execute(true);
              },
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    automaticallyImplyLeading: false, // No back arrow
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    expandedHeight: headerHeight,
                    floating: false,
                    flexibleSpace: const FlexibleSpaceBar(
                      collapseMode: CollapseMode.parallax,
                      centerTitle: true,
                      title: LeaderboardHeaderContent(),
                    ),
                    systemOverlayStyle: const SystemUiOverlayStyle(
                      statusBarColor: Colors.transparent,
                      statusBarIconBrightness: Brightness.dark,
                      statusBarBrightness: Brightness.light,
                      systemNavigationBarIconBrightness: Brightness.dark,
                    ),
                  ),
                  // If there was an error while fetching from origin, display error prompt
                  // only on initial load (`widget.viewModel.users will` be `null`). In other
                  // cases, old list will still be shown, but we will show snackbar.
                  if (widget.viewModel.loadLeaderboard.error &&
                      widget.viewModel.leaderboard == null)
                    // TODO: Usage of a generic error prompt widget
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(top: Dimens.paddingVertical),
                        child: SizedBox.shrink(),
                      ),
                    )
                  else if (widget.viewModel.leaderboard == null)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: Dimens.paddingVertical,
                        ),
                        child: ActivityIndicator(
                          radius: 16,
                          color: Theme.of(builderContext).colorScheme.primary,
                        ),
                      ),
                    )
                  else if (widget.viewModel.leaderboard!.isEmpty)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: Dimens.of(context).paddingScreenHorizontal,
                          right: Dimens.of(context).paddingScreenHorizontal,
                          top: Dimens.paddingVertical * 2,
                        ),
                        child: EmptyDataPlaceholder(
                          assetImage: Assets.emptyLeaderboardIllustration,
                          child: Text(
                            context.localization.leaderboardEmpty,
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    )
                  else
                    LeaderboardList(items: widget.viewModel.leaderboard!),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _onLeaderboardLoadResult() {
    if (widget.viewModel.loadLeaderboard.completed) {
      widget.viewModel.loadLeaderboard.clearResult();
    }

    if (widget.viewModel.loadLeaderboard.error) {
      widget.viewModel.loadLeaderboard.clearResult();
      AppSnackbar.showError(
        context: context,
        message: context.localization.leaderboardLoadError,
      );
    }
  }
}
