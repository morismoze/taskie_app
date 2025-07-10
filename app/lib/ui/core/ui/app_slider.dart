import 'package:flutter/material.dart';

import '../theme/colors.dart';

class AppSlider extends StatelessWidget {
  const AppSlider({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    required this.max,
    required this.min,
    required this.step,
  });

  final String label;
  final double value;
  final void Function(double)? onChanged;
  final int step;
  final double max;
  final double min;

  @override
  Widget build(BuildContext context) {
    final divisions = ((max - min) / step).toInt();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              Text(
                '$label:',
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.grey2,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 5),
              Text(
                value.toInt().toString(),
                style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Slider(
          // This has to be set to false to get new M3 design, because it defaults
          // to true (old design), even though the old design should be depreceated
          year2023: false,
          value: value,
          onChanged: onChanged,
          divisions: divisions,
          max: max,
          min: min,
          label: value.toInt().toString(),
          padding: const EdgeInsets.symmetric(vertical: 15),
          inactiveColor: AppColors.purple1Light,
        ),
      ],
    );
  }
}
