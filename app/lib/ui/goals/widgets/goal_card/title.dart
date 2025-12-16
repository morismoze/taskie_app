import 'package:flutter/material.dart';

class GoalTitle extends StatelessWidget {
  const GoalTitle({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
    );
  }
}
