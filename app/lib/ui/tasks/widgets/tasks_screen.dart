import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/dimens.dart';
import '../../core/ui/activity_indicator.dart';
import '../../core/ui/blurred_circles_background.dart';
import '../view_models/tasks_screen_viewmodel.dart';
import 'empty_filtered_tasks.dart';
import 'empty_tasks.dart';
import 'tasks_header.dart';
import 'tasks_list.dart';
import 'tasks_sorting/tasks_sorting_header.dart';

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
  }

  @override
  void didUpdateWidget(covariant TasksScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlurredCirclesBackground(
      child: SafeArea(
        child: Column(
          children: [
            ListenableBuilder(
              listenable: widget.viewModel,
              builder: (builderContext, _) {
                if (widget.viewModel.user != null) {
                  return TasksHeader(viewModel: widget.viewModel);
                }
                return const SizedBox.shrink();
              },
            ),
            Expanded(
              child: ListenableBuilder(
                listenable: widget.viewModel,
                builder: (builderContext, _) {
                  if (widget.viewModel.isInitialLoad) {
                    return ActivityIndicator(
                      radius: 16,
                      color: Theme.of(builderContext).colorScheme.primary,
                    );
                  }

                  // If there was an error while fetching from origin, display error prompt
                  // only on initial load. In other cases, old list will still be shown, but
                  // we will show snackbar.
                  if (widget.viewModel.isInitialLoad &&
                      widget.viewModel.loadTasks.error) {
                    // TODO: Usage of a generic error prompt widget
                    return const SizedBox.shrink();
                  }

                  // If there are no tasks on initial load (without any specific
                  // filters), then workspace doesn't have any tasks yet - this is
                  // not correct because workspaces can have closed tasks and no
                  if (widget.viewModel.isInitialLoad &&
                      widget.viewModel.tasks!.total == 0) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Dimens.paddingHorizontal,
                      ),
                      child: EmptyTasks(
                        activeWorkspaceId: widget.viewModel.activeWorkspaceId,
                      ),
                    );
                  }

                  // We don't have the standard 'First ListenableBuilder listening to a command
                  // and its child is the second ListenableBuilder listening to viewModel' because
                  // we want to show [ActivityIndicator] only on the initial load. All other loads
                  // after that will happen when user pulls-to-refresh (and if the app process was not
                  // killed by the underlying OS). And in that case we want to show the existing
                  // list and only the refresh indicator loader - not [ActivityIndicator] everytime.
                  return Padding(
                    padding: const EdgeInsets.only(
                      top: Dimens.paddingVertical / 2,
                    ),
                    child: Column(
                      spacing: Dimens.paddingVertical / 2,
                      children: [
                        TasksSortingHeader(viewModel: widget.viewModel),
                        if (widget.viewModel.tasks!.total > 0)
                          Expanded(
                            child: RefreshIndicator(
                              onRefresh: () async {
                                widget.viewModel.loadTasks.execute((
                                  null,
                                  true,
                                ));
                              },
                              child: TasksList(viewModel: widget.viewModel),
                            ),
                          )
                        else
                          const EmptyFilteredTasks(),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
