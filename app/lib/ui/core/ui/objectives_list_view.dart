import 'package:flutter/material.dart';
import 'package:number_paginator/number_paginator.dart';

import '../../../domain/models/filter.dart';
import '../../navigation/app_fab/widgets/app_floating_action_button.dart';
import '../theme/dimens.dart';

/// Represents a layer of abstraction for the list of objectives (tasks
/// or goals) on Tasks and Goals screes.
class ObjectivesListView extends StatefulWidget {
  const ObjectivesListView({
    super.key,
    required this.headerDelegate,
    required this.list,
    required this.totalPages,
    required this.currentFilter,
    required this.onPageChange,
  });

  final SliverPersistentHeaderDelegate headerDelegate;
  final Widget list;
  final ObjectiveFilter currentFilter;
  final int totalPages;

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

    final paginatorCurrentPage = _controller.currentPage + 1;
    final repositoryCurrentPage = widget.currentFilter.page;

    // This case can happen when the user closes all tasks/goals of the current page
    // and then we need to change the current page. This currentPage should only
    // visually change to the provided page and not invoke onPageChange.
    if (paginatorCurrentPage != repositoryCurrentPage) {
      _controller.currentPage = repositoryCurrentPage - 1;
    }

    // Scroll to top when filter is changed
    if (widget.currentFilter != oldWidget.currentFilter) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
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
                    Dimens.paddingVertical * 1.5 + kAppFloatingActionButtonSize,
                left: Dimens.of(context).paddingScreenHorizontal,
                right: Dimens.of(context).paddingScreenHorizontal,
              ),
              child: NumberPaginator(
                controller: _controller,
                numberPages: widget.totalPages,
                // [page] param starts from 0
                onPageChange: (page) {
                  widget.onPageChange(page + 1);
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
      ],
    );
  }
}
