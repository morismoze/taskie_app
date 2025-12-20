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
import '../view_models/tasks_screen_viewmodel.dart';
import 'tasks_header.dart';
import 'tasks_list.dart';
import 'tasks_sorting/tasks_sorting_header_delegate.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key, required this.viewModel});

  final TasksScreenViewModel viewModel;

  @override
  State<StatefulWidget> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
    widget.viewModel.loadTasks.addListener(_onLoadTasksResult);
  }

  @override
  void didUpdateWidget(covariant TasksScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.viewModel.loadTasks.removeListener(_onLoadTasksResult);
    widget.viewModel.loadTasks.addListener(_onLoadTasksResult);
  }

  @override
  void dispose() {
    widget.viewModel.loadTasks.removeListener(_onLoadTasksResult);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlurredCirclesBackground(
      child: Column(
        children: [
          TasksHeader(viewModel: widget.viewModel),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                bottom: kAppBottomNavigationBarHeight,
              ),
              child: ListenableBuilder(
                listenable: Listenable.merge([
                  widget.viewModel.loadTasks,
                  widget.viewModel,
                ]),
                builder: (builderContext, _) {
                  // Show loader only on initial load (tasks are null)
                  if (widget.viewModel.loadTasks.running &&
                      widget.viewModel.tasks == null) {
                    return ActivityIndicator(
                      radius: 16,
                      color: Theme.of(builderContext).colorScheme.primary,
                    );
                  }

                  // Show error prompt only on initial load (tasks are null)
                  if (widget.viewModel.loadTasks.error &&
                      widget.viewModel.tasks == null) {
                    return Padding(
                      padding: const EdgeInsets.only(
                        bottom: kAppBottomNavigationBarHeight,
                      ),
                      child: ErrorPrompt(
                        onRetry: () =>
                            widget.viewModel.loadTasks.execute((null, true)),
                      ),
                    );
                  }

                  // If it is initial load and tasks are empty (not null),
                  // show Create new task prompt
                  if (!widget.viewModel.isFilterSearch &&
                      widget.viewModel.tasks!.total == 0) {
                    return RefreshIndicator(
                      onRefresh: () async {
                        widget.viewModel.loadTasks.execute((null, true));
                        widget.viewModel.refreshUser.execute();
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
                                    child: context.localization.tasksNoTasks
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
                      widget.viewModel.loadTasks.execute((null, true));
                      widget.viewModel.refreshUser.execute();
                    },
                    child: ObjectivesListView(
                      headerDelegate: TasksSortingHeaderDelegate(
                        viewModel: widget.viewModel,
                        height: 50,
                      ),
                      list: TasksList(viewModel: widget.viewModel),
                      totalPages: widget.viewModel.tasks!.totalPages,
                      onPageChange: (page) {
                        final updatedFilter = widget.viewModel.activeFilter
                            .copyWith(page: page + 1);
                        widget.viewModel.loadTasks.execute((
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

  void _onLoadTasksResult() {
    if (widget.viewModel.loadTasks.completed) {
      widget.viewModel.loadTasks.clearResult();
    }

    if (widget.viewModel.loadTasks.error) {
      // Show snackbar only in the case there already is some
      // cached data - basically when pull-to-refresh happens.
      // On the first load and error we display the ErrorPrompt widget.
      if (widget.viewModel.tasks != null) {
        widget.viewModel.loadTasks.clearResult();
        AppSnackbar.showError(
          context: context,
          message: context.localization.tasksLoadRefreshError,
        );
      }
    }
  }
}
