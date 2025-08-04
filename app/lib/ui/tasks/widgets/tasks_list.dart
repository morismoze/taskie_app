import 'package:flutter/material.dart';
import 'package:number_paginator/number_paginator.dart';

import '../../core/theme/dimens.dart';
import '../../navigation/app_fab/widgets/app_floating_action_button.dart';
import '../view_models/tasks_screen_viewmodel.dart';
import 'empty_filtered_tasks.dart';
import 'task_card/card.dart';
import 'tasks_sorting/tasks_sorting_header_delegate.dart';

class TasksList extends StatelessWidget {
  const TasksList({super.key, required this.viewModel});

  final TasksScreenViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: EdgeInsets.symmetric(
            horizontal: Dimens.of(context).paddingScreenHorizontal,
          ),
          sliver: SliverPersistentHeader(
            delegate: TasksSortingHeaderDelegate(
              viewModel: viewModel,
              height: 50,
            ),
            pinned: false,
            floating: true,
          ),
        ),
        if (viewModel.tasks!.total > 0) ...[
          SliverPadding(
            padding: EdgeInsets.symmetric(
              horizontal: Dimens.of(context).paddingScreenHorizontal,
              vertical: Dimens.paddingVertical,
            ),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final task = viewModel.tasks!.items[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: TaskCard(
                    appLocale: viewModel.appLocale,
                    activeWorkspaceId: viewModel.activeWorkspaceId,
                    taskId: task.id,
                    title: task.title,
                    assignees: task.assignees,
                    rewardPoints: task.rewardPoints,
                    dueDate: task.dueDate,
                    isNew: task.isNew,
                  ),
                );
              }, childCount: viewModel.tasks!.items.length),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(
                bottom:
                    Dimens.paddingVertical * 1.5 + kAppFloatingActionButtonSize,
                left: Dimens.of(context).paddingScreenHorizontal,
                right: Dimens.of(context).paddingScreenHorizontal,
              ),
              child: NumberPaginator(
                numberPages: viewModel.tasks!.totalPages,
                // [page] param starts from 0
                onPageChange: (page) {
                  final updatedFilter = viewModel.activeFilter.copyWith(
                    page: page + 1,
                  );
                  viewModel.loadTasks.execute((updatedFilter, null));
                },
                child: const SizedBox(
                  height: 48,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      PrevButton(),
                      Flexible(
                        child: ScrollableNumberContent(shrinkWrap: true),
                      ),
                      NextButton(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ] else
          const SliverFillRemaining(
            hasScrollBody: false,
            child: EmptyFilteredTasks(),
          ),
      ],
    );
  }
}
