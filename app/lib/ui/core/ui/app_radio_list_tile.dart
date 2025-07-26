import 'package:flutter/material.dart';

import '../theme/colors.dart';

class AppRadioListTile<T> extends StatelessWidget {
  const AppRadioListTile({
    super.key,
    required this.groupValue,
    required this.value,
    required this.title,
    this.onChanged,
  });

  final T groupValue;
  final T value;
  final Widget title;
  final void Function(T?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return RadioListTile<T>(
      contentPadding: const EdgeInsets.only(left: 0),
      groupValue: groupValue,
      value: value,
      title: title,
      onChanged: onChanged,
      activeColor: Theme.of(context).colorScheme.primary,
      overlayColor: const WidgetStateProperty.fromMap(
        <WidgetStatesConstraint, Color>{WidgetState.any: AppColors.grey3},
      ),
    );
  }
}
