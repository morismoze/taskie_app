import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../config/assets.dart';
import '../../core/l10n/l10n_extensions.dart';
import '../../core/theme/dimens.dart';
import '../../core/ui/activity_indicator.dart';
import '../../core/ui/app_toast.dart';
import '../../core/ui/blurred_circles_background.dart';
import '../../core/ui/empty_data_placeholder.dart';
import '../../core/ui/error_prompt.dart';
import '../../navigation/app_bottom_navigation_bar/widgets/app_bottom_navigation_bar.dart';
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
    super.initState();
    widget.viewModel.loadLeaderboard.addListener(_onLeaderboardLoadResult);
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

    return Scaffold(
      body: BlurredCirclesBackground(
        child: ListenableBuilder(
          listenable: Listenable.merge([
            widget.viewModel.loadLeaderboard,
            widget.viewModel,
          ]),
          builder: (builderContext, child) {
            return CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
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
                CupertinoSliverRefreshControl(
                  onRefresh: () async =>
                      await widget.viewModel.loadLeaderboard.execute(true),
                  refreshTriggerPullDistance: 150,
                ),
                // Display error prompt only on initial load. In other cases, old list
                // will still be shown, but we will show error snackbar.
                if (widget.viewModel.loadLeaderboard.error &&
                    widget.viewModel.leaderboard == null)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: Dimens.paddingVertical,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          bottom: kAppBottomNavigationBarHeight,
                        ),
                        child: ErrorPrompt(
                          onRetry: () =>
                              widget.viewModel.loadLeaderboard.execute(true),
                        ),
                      ),
                    ),
                  )
                else if (widget.viewModel.leaderboard == null)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(top: Dimens.paddingVertical),
                      child: ActivityIndicator(radius: 16),
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
      // Show snackbar only in the case there already is some
      // cached data - basically when pull-to-refresh happens.
      // On the first load and error we display the ErrorPrompt widget.
      if (widget.viewModel.leaderboard != null) {
        widget.viewModel.loadLeaderboard.clearResult();
        AppToast.showError(
          context: context,
          message: context.localization.leaderboardLoadRefreshError,
        );
      }
    }
  }
}
