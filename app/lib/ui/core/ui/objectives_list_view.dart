import 'package:flutter/material.dart';
import 'package:number_paginator/number_paginator.dart';

import '../../navigation/app_fab/widgets/app_floating_action_button.dart';
import '../theme/dimens.dart';

/// Represents a layer of abstraction for the list of objectives (tasks
/// or goals) on Tasks and Goals screes.
class ObjectivesListView extends StatelessWidget {
  const ObjectivesListView({
    super.key,
    required this.headerDelegate,
    required this.list,
    required this.totalPages,
    required this.onPageChange,
  });

  final SliverPersistentHeaderDelegate headerDelegate;
  final Widget list;
  final int totalPages;

  /// [page] param starts from 0
  final Function(int page0) onPageChange;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: EdgeInsets.symmetric(
            horizontal: Dimens.of(context).paddingScreenHorizontal,
          ),
          sliver: SliverPersistentHeader(
            delegate: headerDelegate,
            pinned: false,
            floating: true,
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.symmetric(
            horizontal: Dimens.of(context).paddingScreenHorizontal,
            vertical: Dimens.paddingVertical,
          ),
          sliver: list,
        ),
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
              numberPages: totalPages,
              // [page] param starts from 0
              onPageChange: onPageChange,
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
