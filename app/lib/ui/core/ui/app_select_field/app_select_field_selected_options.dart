import 'package:flutter/material.dart';

import '../../theme/colors.dart';
import '../app_field_button.dart';
import 'app_select_field.dart';

/// This abstraction is made so that the same select field with
/// pre-selected options can be used in the AppSelectField widget
/// and in the TaskDetailsEditForm/GoalDetailsEditForm widgets - in
/// these form widgets, this widget is used as a "tappable button",
/// rather than a select field, hence why this layer of abstraction
/// is needed.
class AppSelectFieldSelectedOptions extends StatelessWidget {
  const AppSelectFieldSelectedOptions({
    super.key,
    required this.label,
    required this.selectedOptions,
    required this.isFieldFocused,
    required this.onTap,
    this.required = true,
    this.enabled = true,
    this.trailing,
  });

  final String label;
  final List<AppSelectFieldOption> selectedOptions;
  final bool isFieldFocused;
  final void Function() onTap;
  final bool required;
  final bool enabled;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return AppFieldButton(
      label: label,
      required: required,
      isFieldFocused: isFieldFocused,
      onTap: onTap,
      trailing: trailing,
      child: Wrap(
        spacing: 4,
        runSpacing: 4,
        children: selectedOptions
            .map(
              (option) => _AppSelectFieldSelectedOption(
                label: option.label,
                isFieldEnabled: enabled,
              ),
            )
            .toList(),
      ),
    );
  }
}

class _AppSelectFieldSelectedOption extends StatelessWidget {
  const _AppSelectFieldSelectedOption({
    required this.label,
    this.isFieldEnabled = true,
  });

  final String label;
  final bool isFieldEnabled;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 150),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: isFieldEnabled
                ? AppColors.grey2
                : Theme.of(context).disabledColor,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(
                context,
              ).textTheme.bodySmall!.copyWith(color: AppColors.white1),
            ),
          ),
        ),
      ),
    );
  }
}
