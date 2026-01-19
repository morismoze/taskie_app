import 'package:flutter/material.dart';

import '../../theme/colors.dart';
import '../../theme/dimens.dart';
import '../app_field_button.dart';
import 'app_select_field.dart';

/// This abstraction widget is made so that the same select field with
/// pre-selected options can be used in the AppSelectField widget and
/// as a selected-options-display-widget (e.g. used as a "tappable
/// button", rather than a select field).
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
            padding: const EdgeInsets.symmetric(
              vertical: Dimens.paddingVertical / 6,
              horizontal: Dimens.paddingHorizontal / 2,
            ),
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
