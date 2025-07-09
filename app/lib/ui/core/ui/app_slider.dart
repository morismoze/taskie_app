import 'package:flutter/material.dart';

import '../theme/colors.dart';

class AppSlider extends StatelessWidget {
  const AppSlider({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    required this.divisions,
    required this.max,
    required this.min,
  });

  final String label;
  final double value;
  final void Function(double)? onChanged;
  final int divisions;
  final double max;
  final double min;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.grey2,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Slider(
          value: value,
          onChanged: onChanged,
          divisions: divisions,
          max: max,
          min: min,
        ),
      ],
    );
  }
}
