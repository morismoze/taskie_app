import 'package:flutter/material.dart';

/// Simple reusable widget representing plain Text child for LabeledData widget.
class LabeledDataText extends StatelessWidget {
  const LabeledDataText({super.key, required this.data});

  final String data;

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: Theme.of(
        context,
      ).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.normal),
    );
  }
}
