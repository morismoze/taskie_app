import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:number_paginator/number_paginator.dart';

import '../../../config/assets.dart';
import '../../../domain/models/filter.dart';
import '../../navigation/app_fab/widgets/app_floating_action_button.dart';
import '../l10n/l10n_extensions.dart';
import '../theme/dimens.dart';
import '../utils/extensions.dart';
import 'empty_data_placeholder.dart';

/// Represents a layer of abstraction for the list of objectives (tasks
/// or goals) on Tasks and Goals screes.
class ObjectivesListView extends StatefulWidget {
  const ObjectivesListView({
    super.key,
    required this.headerDelegate,
    required this.list,
    required this.totalPages,
    required this.total,
    required this.isFilterSearch,
    required this.currentFilter,
    required this.onPageChange,
    required this.onRefresh,
  });

  final SliverPersistentHeaderDelegate headerDelegate;
  final Widget list;
  final ObjectiveFilter currentFilter;
  final int totalPages;
  final int total;
  final bool isFilterSearch;
  final Future<void> Function() onRefresh;

  /// [page] param starts from 0
  final Function(int page0) onPageChange;

  @override
  State<ObjectivesListView> createState() => _ObjectivesListViewState();
}

class _ObjectivesListViewState extends State<ObjectivesListView> {
  final NumberPaginatorController _controller = NumberPaginatorController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ObjectivesListView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.currentFilter != oldWidget.currentFilter) {
      final paginatorCurrentPage = _controller.currentPage + 1;
      final repositoryCurrentPage = widget.currentFilter.page;

      // This case can happen when the user closes all tasks/goals of the current page
      // and then we need to change the current page. This currentPage should only
      // visually change to the provided page and not invoke onPageChange.
      if (paginatorCurrentPage != repositoryCurrentPage) {
        _controller.currentPage = repositoryCurrentPage - 1;
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onPageChange(int page) {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
    widget.onPageChange(page + 1);
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      slivers: [
        CupertinoSliverRefreshControl(
          onRefresh: widget.onRefresh,
          refreshTriggerPullDistance: 150,
        ),
        SliverPadding(
          padding: EdgeInsets.symmetric(
            horizontal: Dimens.of(context).paddingScreenHorizontal,
          ),
          sliver: SliverPersistentHeader(
            delegate: widget.headerDelegate,
            pinned: false,
            floating: true,
          ),
        ),
        // If it is not filter search and objectives are empty (not null),
        // show Create new task prompt
        if (widget.total == 0 && !widget.isFilterSearch)
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(
                left: Dimens.of(context).paddingScreenHorizontal,
                right: Dimens.of(context).paddingScreenHorizontal,
                top: Dimens.paddingVertical * 2,
              ),
              child: EmptyDataPlaceholder(
                assetImage: Assets.emptyObjectivesIllustration,
                child: context.localization.tasksNoTasks.toStyledText(
                  style: Theme.of(context).textTheme.bodyMedium!,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          )
        else ...[
          SliverPadding(
            padding: EdgeInsets.symmetric(
              horizontal: Dimens.of(context).paddingScreenHorizontal,
              vertical: Dimens.paddingVertical,
            ),
            sliver: widget.list,
          ),
          if (widget.totalPages > 0)
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(
                  top: Dimens.paddingVertical / 2,
                  bottom:
                      Dimens.paddingVertical * 1.5 +
                      kAppFloatingActionButtonSize,
                  left: Dimens.of(context).paddingScreenHorizontal,
                  right: Dimens.of(context).paddingScreenHorizontal,
                ),
                child: NumberPaginator(
                  controller: _controller,
                  numberPages: widget.totalPages,
                  // [page] param starts from 0
                  onPageChange: _onPageChange,
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
        ],
      ],
    );
  }
}
