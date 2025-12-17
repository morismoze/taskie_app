import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../config/assets.dart';
import '../../core/l10n/l10n_extensions.dart';
import '../../core/theme/dimens.dart';
import '../../core/ui/activity_indicator.dart';
import '../../core/ui/blurred_circles_background.dart';
import '../../core/ui/empty_data_placeholder.dart';
import '../../core/ui/objectives_list_view.dart';
import '../../core/utils/extensions.dart';
import '../../navigation/app_bottom_navigation_bar/widgets/app_bottom_navigation_bar.dart';
import '../view_models/goals_screen_viewmodel.dart';
import 'goals_header.dart';
import 'goals_list.dart';
import 'goals_sorting/goals_sorting_header_delegate.dart';

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key, required this.viewModel});

  final GoalsScreenViewmodel viewModel;

  @override
  State<StatefulWidget> createState() => _GoalssScreenState();
}

class _GoalssScreenState extends State<GoalsScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlurredCirclesBackground(
      child: Column(
        children: [
          GoalsHeader(viewModel: widget.viewModel),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                bottom: kAppBottomNavigationBarHeight,
              ),
              child: ListenableBuilder(
                listenable: widget.viewModel,
                builder: (builderContext, _) {
                  // If the goals are null (before initial load) amd there was an error while fetching
                  // from origin, display error prompt. In other cases, old list will still be shown, but
                  // we will show a error snackbar.
                  if (widget.viewModel.goals == null &&
                      widget.viewModel.loadGoals.error) {
                    // TODO: Usage of a generic error prompt widget
                    return const SizedBox.shrink();
                  }

                  // If the goals are null (before initial load) show activity indicator.
                  if (widget.viewModel.goals == null) {
                    return ActivityIndicator(
                      radius: 16,
                      color: Theme.of(builderContext).colorScheme.primary,
                    );
                  }

                  // If it is initial load and goals are empty (not null),
                  // show Create new goal prompt
                  if (!widget.viewModel.isFilterSearch &&
                      widget.viewModel.goals!.total == 0) {
                    return RefreshIndicator(
                      onRefresh: () async {
                        widget.viewModel.loadGoals.execute((null, true));
                      },
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return SingleChildScrollView(
                            // Enables scrolling and trigger of pull-to-refresh
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minHeight: constraints.maxHeight,
                              ),
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    bottom: kAppBottomNavigationBarHeight,
                                    left: Dimens.of(
                                      context,
                                    ).paddingScreenHorizontal,
                                    right: Dimens.of(
                                      context,
                                    ).paddingScreenHorizontal,
                                  ),
                                  child: EmptyDataPlaceholder(
                                    assetImage:
                                        Assets.emptyObjectivesIllustration,
                                    child: context.localization.goalsNoGoals
                                        .format(
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodyMedium!,
                                          textAlign: TextAlign.center,
                                        ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }

                  // We don't have the standard 'First ListenableBuilder listening to a command
                  // and its child is the second ListenableBuilder listening to viewModel' because
                  // we want to show [ActivityIndicator] only on the initial load. All other loads
                  // after that will happen when user pulls-to-refresh (and if the app process was not
                  // killed by the underlying OS). And in that case we want to show the existing
                  // list and only the refresh indicator loader - not [ActivityIndicator] everytime.
                  return RefreshIndicator(
                    onRefresh: () async {
                      widget.viewModel.loadGoals.execute((null, true));
                    },
                    child: ObjectivesListView(
                      headerDelegate: GoalsSortingHeaderDelegate(
                        viewModel: widget.viewModel,
                        height: 50,
                      ),
                      list: GoalsList(viewModel: widget.viewModel),
                      totalPages: widget.viewModel.goals!.totalPages,
                      onPageChange: (page) {
                        final updatedFilter = widget.viewModel.activeFilter
                            .copyWith(page: page + 1);
                        widget.viewModel.loadGoals.execute((
                          updatedFilter,
                          null,
                        ));
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
