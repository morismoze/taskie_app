import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/dimens.dart';
import '../../core/ui/activity_indicator.dart';
import '../../core/ui/blurred_circles_background.dart';
import '../../core/utils/constants.dart';
import '../view_models/tasks_screen_viewmodel.dart';
import 'task_card/card.dart';
import 'tasks_header.dart';

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
      const SystemUiOverlayStyle(statusBarIconBrightness: Brightness.dark),
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
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.only(
            bottom: kAppBottomNavigationBarHeight + Dimens.paddingVertical,
          ),
          child: Column(
            children: [
              ListenableBuilder(
                listenable: widget.viewModel,
                builder: (builderContext, _) {
                  if (widget.viewModel.user != null) {
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: Dimens.of(context).paddingScreenHorizontal,
                      ),
                      child: TasksHeader(viewModel: widget.viewModel),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              Expanded(
                child: ListenableBuilder(
                  listenable: widget.viewModel,
                  builder: (builderContext, _) {
                    if (widget.viewModel.tasks == null) {
                      return ActivityIndicator(
                        radius: 16,
                        color: Theme.of(builderContext).colorScheme.primary,
                      );
                    }

                    // If there was an error while fetching from origin, display error prompt
                    // only on initial load (`widget.viewModel.tasks will` be `null`). In other
                    // cases, old list will still be shown, but we will show snackbar.
                    if (widget.viewModel.loadTasks.error &&
                        widget.viewModel.tasks == null) {
                      // TODO: Usage of a generic error prompt widget
                      return const SizedBox.shrink();
                    }

                    // We don't have the standard 'First ListenableBuilder listening to a command
                    // and its child is the second ListenableBuilder listening to viewModel' because
                    // we want to show [ActivityIndicator] only on the initial load. All other loads
                    // after that will happen when user pulls-to-refresh (and if the app process was not
                    // killed by the underlying OS). And in that case we want to show the existing
                    // list and only the refresh indicator loader - not [ActivityIndicator] everytime.
                    return RefreshIndicator(
                      displacement: 30,
                      onRefresh: () async {
                        widget.viewModel.loadTasks.execute((null, true));
                      },
                      child: ListView.separated(
                        padding: EdgeInsets.only(
                          bottom: 20,
                          left: Dimens.of(context).paddingScreenHorizontal,
                          right: Dimens.of(context).paddingScreenHorizontal,
                        ),
                        itemCount: widget.viewModel.tasks!.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 10),
                        itemBuilder: (_, index) {
                          final task = widget.viewModel.tasks![index];

                          return TaskCard(
                            appLocale: widget.viewModel.appLocale,
                            title: task.title,
                            assignees: task.assignees,
                            rewardPoints: task.rewardPoints,
                            dueDate: task.dueDate,
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
