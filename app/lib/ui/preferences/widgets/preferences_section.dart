import 'package:flutter/material.dart';

import '../../core/theme/dimens.dart';

class PreferencesSection extends StatelessWidget {
  const PreferencesSection({
    super.key,
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Dimens.of(context).paddingScreenHorizontal,
      ),
      child: Column(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
          ),
          Column(spacing: 15, children: children.toList()),
        ],
      ),
    );
  }
}
