import 'package:flutter/material.dart';

class LabeledData extends StatelessWidget {
  const LabeledData({super.key, required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 8,
      children: [
        Text(
          '$label: ',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
        ),
        child,
      ],
    );
  }
}
