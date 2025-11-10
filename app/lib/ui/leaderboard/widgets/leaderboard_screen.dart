import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../config/assets.dart';
import '../../core/l10n/l10n_extensions.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/dimens.dart';
import '../../core/ui/activity_indicator.dart';
import '../../core/ui/app_snackbar.dart';
import '../../core/ui/blurred_circles_background.dart';
import '../../navigation/app_fab/widgets/app_floating_action_button.dart';
import '../view_models/leaderboard_screen_view_model.dart';
import 'leaderboard_user_tile.dart';

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
    return Scaffold(
      body: BlurredCirclesBackground(
        child: ListenableBuilder(
          listenable: widget.viewModel,
          builder: (builderContext, child) {
            if (widget.viewModel.leaderboard == null) {
              return ActivityIndicator(
                radius: 16,
                color: Theme.of(builderContext).colorScheme.primary,
              );
            }

            // If there was an error while fetching from origin, display error prompt
            // only on initial load (`widget.viewModel.users will` be `null`). In other
            // cases, old list will still be shown, but we will show snackbar.
            if (widget.viewModel.loadLeaderboard.error) {
              // TODO: Usage of a generic error prompt widget
              return const SizedBox.shrink();
            }

            final items = widget.viewModel.leaderboard!;

            // We don't have the standard 'First ListenableBuilder listening to a command
            // and its child is the second ListenableBuilder listening to viewModel' because
            // we want to show [ActivityIndicator] only on the initial load. All other loads
            // after that will happen when user pulls-to-refresh (and if the app process was not
            // killed by the underlying OS). And in that case we want to show the existing
            // list and only the refresh indicator loader - not [ActivityIndicator] everytime.
            return RefreshIndicator(
              displacement: 30,
              onRefresh: () async {
                widget.viewModel.loadLeaderboard.execute(true);
              },
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverAppBar(
                    automaticallyImplyLeading: false, // No back arrow
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    expandedHeight:
                        MediaQuery.of(context).size.height *
                        0.15, // Image height
                    pinned: false, // Disappear on scroll
                    floating: false,
                    stretch: true, // "pull to stretch" efect
                    flexibleSpace: FlexibleSpaceBar(
                      collapseMode: CollapseMode.parallax,
                      centerTitle: true,
                      title: Column(
                        spacing: Dimens.paddingVertical / 3,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            spacing: Dimens.paddingVertical / 6,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(bottom: 4),
                                child: Image(
                                  image: AssetImage(Assets.laurelWreathLeft),
                                  width: 25,
                                ),
                              ),
                              Text(
                                context.localization.leaderboardLabel,
                                style: Theme.of(context).textTheme.titleLarge!
                                    .copyWith(
                                      color: AppColors.golden,
                                      fontWeight: FontWeight.bold,
                                      height: 1,
                                    ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(bottom: 4),
                                child: Image(
                                  image: AssetImage(Assets.laurelWreathRight),
                                  width: 25,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            context.localization.leaderboardSubtitle,
                            style: Theme.of(context).textTheme.labelMedium!
                                .copyWith(
                                  color: AppColors.grey3,
                                  fontWeight: FontWeight.normal,
                                ),
                          ),
                        ],
                      ),
                    ),
                    systemOverlayStyle: const SystemUiOverlayStyle(
                      statusBarColor: Colors.transparent,
                      statusBarIconBrightness: Brightness.dark,
                      statusBarBrightness: Brightness.light,
                      systemNavigationBarIconBrightness: Brightness.dark,
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.only(
                      left: Dimens.of(context).paddingScreenHorizontal,
                      right: Dimens.of(context).paddingScreenHorizontal * 1.5,
                      top: Dimens.paddingVertical,
                      bottom:
                          Dimens.paddingVertical * 1.5 +
                          kAppFloatingActionButtonSize +
                          kBottomNavigationBarHeight,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final user = items[index];

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: LeaderboardUserTile(
                            placement: index + 1,
                            userId: user.id,
                            firstName: user.firstName,
                            lastName: user.lastName,
                            profileImageUrl: user.profileImageUrl,
                            accumulatedPoints: user.accumulatedPoints,
                            completedTasks: user.completedTasks,
                          ),
                        );
                      }, childCount: items.length),
                    ),
                  ),
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
