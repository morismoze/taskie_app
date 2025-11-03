import 'package:flutter/material.dart';

import '../utils/widgets.dart';

class GuideSection extends StatelessWidget {
  const GuideSection({super.key, required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final bodyFormattedWidget = WidgetsUtils.buildFormattedText(
      context: context,
      text: body,
      style: Theme.of(context).textTheme.bodyLarge!,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        bodyFormattedWidget,
      ],
    );
  }
}
