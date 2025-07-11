import 'package:flutter/material.dart';

import '../theme/colors.dart';

class AppCheckbox extends StatelessWidget {
  const AppCheckbox({super.key, required this.isChecked, this.onChanged});

  final bool isChecked;
  final void Function(bool?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: isChecked,
      onChanged: onChanged,
      checkColor: AppColors.white1,
      fillColor: WidgetStateProperty.fromMap(<WidgetStatesConstraint, Color>{
        WidgetState.selected: Theme.of(context).colorScheme.primary,
      }),
    );
  }
}
