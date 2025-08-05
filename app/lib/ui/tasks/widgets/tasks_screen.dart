import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/dimens.dart';
import '../../core/ui/activity_indicator.dart';
import '../../core/ui/blurred_circles_background.dart';
import '../../core/ui/objectives_list_view.dart';
import '../view_models/tasks_screen_viewmodel.dart';
import 'empty_tasks.dart';
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
            child: Padding(
              padding: const EdgeInsets.only(
                bottom: kBottomNavigationBarHeight,
              ),
              child: ListenableBuilder(
                listenable: widget.viewModel,
                builder: (builderContext, _) {
                  // If the tasks are null (before initial load) amd there was an error while fetching
                  // from origin, display error prompt. In other cases, old list will still be shown, but
                  // we will show a error snackbar.
                  if (widget.viewModel.tasks == null &&
                      widget.viewModel.loadTasks.error) {
                    // TODO: Usage of a generic error prompt widget
                    return const SizedBox.shrink();
                  }

                  // If the tasks are null (before initial load) show activity indicator.
                  if (widget.viewModel.tasks == null) {
                    return ActivityIndicator(
                      radius: 16,
                      color: Theme.of(builderContext).colorScheme.primary,
                    );
                  }

                  // If it is initial load and tasks are empty (not null),
                  // show Create new task prompt
                  if (!widget.viewModel.isFilterSearch &&
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
                  return RefreshIndicator(
                    onRefresh: () async {
                      widget.viewModel.loadTasks.execute((null, true));
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
}
