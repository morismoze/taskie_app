import 'package:flutter/material.dart';
import 'package:number_paginator/number_paginator.dart';

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
    required this.currentPage,
    required this.onPageChange,
  });

  final SliverPersistentHeaderDelegate headerDelegate;
  final Widget list;
  final int currentPage;
  final int totalPages;

  /// [page] param starts from 0
  final Function(int page0) onPageChange;

  @override
  State<ObjectivesListView> createState() => _ObjectivesListViewState();
}

class _ObjectivesListViewState extends State<ObjectivesListView> {
  final NumberPaginatorController _controller = NumberPaginatorController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ObjectivesListView oldWidget) {
    super.didUpdateWidget(oldWidget);

    final paginatorCurrentPage = _controller.currentPage + 1;
    final repositoryCurrentPage = widget.currentPage;

    // This case can happen for example:
    // 1. When the user closes all tasks/goals of the current page
    // and then we need to re-navigate the user to the previous page
    if (paginatorCurrentPage != repositoryCurrentPage) {
      _controller.navigateToPage(repositoryCurrentPage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
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
                onPageChange: (page) => widget.onPageChange(page + 1),
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

  void _compareRepositoryAndPaginatorCurrentPages() {}
}
