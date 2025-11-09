import 'package:flutter/material.dart';

import '../utils/extensions.dart';

class GuideSection extends StatelessWidget {
  const GuideSection({super.key, required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
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
        body.format(style: Theme.of(context).textTheme.bodyLarge!),
      ],
    );
  }
}
