import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../config/assets.dart';
import '../../core/l10n/l10n_extensions.dart';
import '../../core/theme/dimens.dart';
import '../../core/ui/activity_indicator.dart';
import '../../core/ui/app_snackbar.dart';
import '../../core/ui/blurred_circles_background.dart';
import '../../core/ui/empty_data_placeholder.dart';
import '../../core/ui/error_prompt.dart';
import '../../core/ui/objectives_list_view.dart';
import '../../core/utils/extensions.dart';
import '../../navigation/app_bottom_navigation_bar/widgets/app_bottom_navigation_bar.dart';
import '../view_models/goals_screen_viewmodel.dart';
import 'goals_filtering/goals_filtering_header_delegate.dart';
import 'goals_header.dart';
import 'goals_list.dart';

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
    widget.viewModel.loadGoals.addListener(_onLoadGoalsResult);
  }

  @override
  void didUpdateWidget(covariant GoalsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.viewModel.loadGoals.removeListener(_onLoadGoalsResult);
    widget.viewModel.loadGoals.addListener(_onLoadGoalsResult);
  }

  @override
  void dispose() {
    widget.viewModel.loadGoals.removeListener(_onLoadGoalsResult);
    super.dispose();
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
                listenable: Listenable.merge([
                  widget.viewModel.loadGoals,
                  widget.viewModel,
                ]),
                builder: (builderContext, _) {
                  // Show loader only on initial load (goals are null)
                  if (widget.viewModel.loadGoals.running &&
                      widget.viewModel.goals == null) {
                    return ActivityIndicator(
                      radius: 16,
                      color: Theme.of(builderContext).colorScheme.primary,
                    );
                  }

                  // Show error prompt only on initial load (goals are null)
                  if (widget.viewModel.loadGoals.error &&
                      widget.viewModel.goals == null) {
                    return Padding(
                      padding: const EdgeInsets.only(
                        bottom: kAppBottomNavigationBarHeight,
                      ),
                      child: ErrorPrompt(
                        onRetry: () =>
                            widget.viewModel.loadGoals.execute((null, true)),
                      ),
                    );
                  }

                  // If it is initial load, meaning goals are empty (not null)
                  // and filter is null, show Create new goal prompt
                  if (!widget.viewModel.isFilterSearch &&
                      widget.viewModel.goals!.total == 0) {
                    return RefreshIndicator(
                      onRefresh: () async {
                        widget.viewModel.loadGoals.execute((null, true));
                      },
                      child: LayoutBuilder(
                        builder: (layoutBuilderContext, constraints) {
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
                                      layoutBuilderContext,
                                    ).paddingScreenHorizontal,
                                    right: Dimens.of(
                                      layoutBuilderContext,
                                    ).paddingScreenHorizontal,
                                  ),
                                  child: EmptyDataPlaceholder(
                                    assetImage:
                                        Assets.emptyObjectivesIllustration,
                                    child: layoutBuilderContext
                                        .localization
                                        .goalsNoGoals
                                        .format(
                                          style: Theme.of(
                                            layoutBuilderContext,
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

                  return RefreshIndicator(
                    onRefresh: () async {
                      widget.viewModel.loadGoals.execute((null, true));
                    },
                    child: ObjectivesListView(
                      headerDelegate: GoalsFilteringHeaderDelegate(
                        viewModel: widget.viewModel,
                        height: 50,
                      ),
                      list: GoalsList(viewModel: widget.viewModel),
                      totalPages: widget.viewModel.goals!.totalPages,
                      currentFilter: widget.viewModel.activeFilter,
                      onPageChange: (page) {
                        final updatedFilter = widget.viewModel.activeFilter
                            .copyWith(page: page);
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

  void _onLoadGoalsResult() {
    if (widget.viewModel.loadGoals.completed) {
      widget.viewModel.loadGoals.clearResult();
    }

    if (widget.viewModel.loadGoals.error) {
      // Show snackbar only in the case there already is some
      // cached data - basically when pull-to-refresh happens.
      // On the first load and error we display the ErrorPrompt widget.
      if (widget.viewModel.goals != null) {
        widget.viewModel.loadGoals.clearResult();
        AppSnackbar.showError(
          context: context,
          message: context.localization.goalsLoadRefreshError,
        );
      }
    }
  }
}
