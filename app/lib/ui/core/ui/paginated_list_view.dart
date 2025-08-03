import 'package:flutter/material.dart';
import 'package:number_paginator/number_paginator.dart';

import '../../navigation/app_fab/widgets/app_floating_action_button.dart';
import '../theme/dimens.dart';

class PaginatedListView extends StatelessWidget {
  const PaginatedListView({
    super.key,
    required this.totalPages,
    required this.onPageChange,
    required this.itemBuilder,
    required this.childCount,
  });

  final int totalPages;
  final void Function(int page) onPageChange;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final int childCount;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: EdgeInsets.symmetric(
            horizontal: Dimens.of(context).paddingScreenHorizontal,
          ),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              itemBuilder,
              childCount: childCount,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.only(
              top: 20,
              bottom:
                  Dimens.paddingVertical * 1.5 + kAppFloatingActionButtonSize,
              left: Dimens.of(context).paddingScreenHorizontal,
              right: Dimens.of(context).paddingScreenHorizontal,
            ),
            child: NumberPaginator(
              numberPages: totalPages,
              // [page] param starts from 0
              onPageChange: (page0) => onPageChange(page0),
              child: const SizedBox(
                height: 48,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PrevButton(),
                    Flexible(child: ScrollableNumberContent(shrinkWrap: true)),
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
